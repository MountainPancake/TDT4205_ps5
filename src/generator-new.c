#include <vslc.h>

void generate_stringtable ( void );
void generate_global_variables ( void );
void generate_function ( symbol_t *function );

static void generate_node ( node_t *node );
void generate_main ( symbol_t *first );

#define MIN(a,b) (((a)<(b)) ? (a):(b))
#define RECUR(nd) do { \
    for ( size_t i=0; i<(nd)->n_children; i++ ) \
        generate_node ( (nd)->children[i] );    \
} while ( false )

static const char *record[6] = {
    "%rdi", "%rsi", "%rdx", "%rcx", "%r8", "%r9"
};

static symbol_t *current_function = NULL;



void
generate_program ( void )
{

    size_t n_globals = tlhash_size(global_names);
    symbol_t *global_list[n_globals];
    tlhash_values ( global_names, (void **)&global_list );

    symbol_t *first_function;
    for ( size_t i=0; i<tlhash_size(global_names); i++ )
        if ( global_list[i]->type == SYM_FUNCTION && global_list[i]->seq == 0 )
        {
            first_function = global_list[i];
            break;
        }

    generate_stringtable();
    generate_global_variables();
    generate_main ( first_function );
    for ( size_t i=0; i<tlhash_size(global_names); i++ )
        if ( global_list[i]->type == SYM_FUNCTION )
            generate_function ( global_list[i] );

}



void
generate_stringtable ( void )
{
    puts ( ".section .rodata" );
    puts ( ".intout: .string \"\%ld \"" );
    puts ( ".strout: .string \"\%s \"" );
    puts ( ".errout: .string \"Wrong number of arguments\"" );
    for ( size_t s=0; s<stringc; s++ )
        printf ( ".STR%zu: .string %s\n", s, string_list[s] );
}

void
generate_global_variables ( void )
{
    puts ( ".section .data" );
    size_t nsyms = tlhash_size ( global_names );
    symbol_t *syms[nsyms];
    tlhash_values ( global_names, (void **)&syms );
    for ( size_t n=0; n<nsyms; n++ )
    {
        if ( syms[n]->type == SYM_GLOBAL_VAR )
            printf ( "._%s: .zero 8\n", syms[n]->name );
    }
}

void
generate_main ( symbol_t *first )
{
    puts ( ".globl main" );
    puts ( ".section .text" );
    puts ( "main:" );
    puts ( "\tpushq   %rbp" );
    puts ( "\tmovq    %rsp, %rbp" );

    printf ( "\tsubq\t$1,%%rdi\n" );
    printf ( "\tcmpq\t$%zu,%%rdi\n", first->nparms );
    printf ( "\tjne\tABORT\n" );
    printf ( "\tcmpq\t$0,%%rdi\n" );
    printf ( "\tjz\tSKIP_ARGS\n" );

    printf ( "\tmovq\t%%rdi,%%rcx\n" );
    printf ( "\taddq $%zu, %%rsi\n", 8*first->nparms );
    printf ( "PARSE_ARGV:\n" );
    printf ( "\tpushq %%rcx\n" );
    printf ( "\tpushq %%rsi\n" );

    printf ( "\tmovq\t(%%rsi),%%rdi\n" );
    printf ( "\tmovq\t$0,%%rsi\n" );
    printf ( "\tmovq\t$10,%%rdx\n" );
    printf ( "\tcall\tstrtol\n" );

/*  Now a new argument is an integer in rax */

    printf ( "\tpopq %%rsi\n" );
    printf ( "\tpopq %%rcx\n" );
    printf ( "\tpushq %%rax\n" );
    printf ( "\tsubq $8, %%rsi\n" );
    printf ( "\tloop PARSE_ARGV\n" );

    /* Now the arguments are in order on stack */
    for ( int arg=0; arg<MIN(6,first->nparms); arg++ )
        printf ( "\tpopq\t%s\n", record[arg] );

    printf ( "SKIP_ARGS:\n" );
    printf ( "\tcall\t_%s\n", first->name );
    printf ( "\tjmp\tEND\n" );
    printf ( "ABORT:\n" );
    printf ( "\tmovq\t$.errout, %%rdi\n" );
    printf ( "\tcall puts\n" );

    printf ( "END:\n" );
    puts ( "\tmovq    %rax, %rdi" );
    puts ( "\tcall    exit" );

}

static void
generate_identifier ( node_t *ident )
{
    symbol_t *symbol = ident->entry;
    int64_t argument_offset;
    switch ( symbol->type )
    {
        case SYM_GLOBAL_VAR:
            printf ( "._%s", symbol->name );
            break;
        case SYM_PARAMETER:
            printf ( "%ld(%%rbp)", 8*(symbol->seq+1) );
            break;
        case SYM_LOCAL_VAR:
            printf ( "%ld(%%rbp)", -8*(symbol->seq+1) );
            break;
    }
    printf ("/*%s*/ ", symbol->name);
}

static void
generate_expression ( node_t *expr )
{
    if ( expr->type == IDENTIFIER_DATA )
    {
        printf ( "\tmovq\t" );
        generate_identifier ( expr );
        printf ( ", %%rax\n");
    }
    else if ( expr->type == NUMBER_DATA )
    {
        printf ( "\tmovq\t$%ld, %%rax\n", *(int64_t *)expr->data );
    }
    else if ( expr->n_children == 1 )
    {
      // really there is no need for switch case. This is
      // for future changes to detect unary expressions
      switch ( *((char*)(expr->data)) )
        {
            case '-':
                generate_expression ( expr->children[0] );
                printf ( "\tnegq\t%%rax\n" );
                break;
          }
    }
    else if ( expr->n_children == 2 && expr->data != NULL )
    {
        if ( expr->data != NULL )
        {
            switch ( *((char *)expr->data) )
            {
                case '+':
                    generate_expression ( expr->children[0] );
                    printf ( "\tpushq\t%%rax\n" );
                    generate_expression ( expr->children[1] );
                    printf ( "\taddq\t%%rax, (%%rsp)\n" );
                    printf ( "\tpopq\t%%rax\n" );
                    break;
                case '-':
                    generate_expression ( expr->children[0] );
                    printf ( "\tpushq\t%%rax\n" );
                    generate_expression ( expr->children[1] );
                    printf ( "\tsubq\t%%rax, (%%rsp)\n" );
                    printf ( "\tpopq\t%%rax\n" );
                    break;
                case '*':
                    printf ( "\tpushq\t%%rdx\n" );
                    generate_expression ( expr->children[1] );
                    printf ( "\tpushq\t%%rax\n" );
                    generate_expression ( expr->children[0] );
                    printf ( "\tmulq\t(%%rsp)\n" );
                    printf ( "\tpopq\t%%rdx\n" );
                    printf ( "\tpopq\t%%rdx\n" );
                    break;
                case '/':
                    printf ( "\tpushq\t%%rdx\n" );
                    generate_expression ( expr->children[1] );
                    printf ( "\tpushq\t%%rax\n" );
                    generate_expression ( expr->children[0] );
                    printf ( "\tcqo\n" );
                    printf ( "\tidivq\t(%%rsp)\n" );
                    printf ( "\tpopq\t%%rdx\n" );
                    printf ( "\tpopq\t%%rdx\n" );
                    break;
            }
        }
    } else {
        node_t *id = expr->children[0];
        node_t *args = expr->children[1];
        printf("/* function call %s */\n", id->entry->name);
        if (args != NULL) {
            for (int i = args->n_children-1; i >= 0; i--) {
                generate_expression(args->children[i]);
                if (i < 6) {
                    printf("\tmovq \t%%rax, %s\n", record[i]);
                } else {
                    printf("\tpushq \t%%rax\n");
                }
            }
        }
        printf("\tcall \t_%s\n", id->entry->name);
    }
}

static void
generate_assignment_statement ( node_t *statement )
{
    generate_expression ( statement->children[1] );
    printf ( "\tmovq\t%%rax, " );
    generate_identifier ( statement->children[0] );
    printf ( "\n" );
}

static void
generate_print_statement ( node_t *statement )
{
    for ( size_t i=0; i<statement->n_children; i++ )
    {
        node_t *item = statement->children[i];
        switch ( item->type )
        {
            case STRING_DATA:
                printf ( "\tmovq\t$.STR%zu, %%rsi\n", *((size_t *)item->data) );
                printf ( "\tmovq\t$.strout, %%rdi\n" );
                puts ( "\tcall\tprintf" );
                break;
            case NUMBER_DATA:
                printf ("\tmovq\t$%ld, %%rsi\n", *((int64_t *)item->data) );
                printf ( "\tmovq\t$.intout, %%rdi\n" );
                puts ( "\tcall\tprintf" );
                break;
            case IDENTIFIER_DATA:
                printf ( "\tmovq\t" );
                generate_identifier ( item );
                printf ( ", %%rsi\n");
                printf ( "\tmovq\t$.intout, %%rdi\n");
                puts ( "\tcall\tprintf" );
                break;
            case EXPRESSION:
                generate_expression ( item );
                printf ( "\tmovq\t%%rax, %%rsi\n" );
                printf ( "\tmovq\t$.intout, %%rdi\n" );
                puts ( "\tcall\tprintf" );
                break;
        }
    }
    printf ( "\tmovq\t$0x0A, %%rdi\n" );
    puts ( "\tcall\tputchar" );
}

static void
generate_node ( node_t *node )
{
    switch (node->type)
    {
        case PRINT_STATEMENT:
            generate_print_statement ( node );
            break;
        case ASSIGNMENT_STATEMENT:
            generate_assignment_statement ( node );
            break;
        case RETURN_STATEMENT:
            generate_expression ( node->children[0] );
            printf ( "\tmov\t%%rbp, %%rsp\n" );
            printf ( "\tleave\n" );
            printf ( "\tret\n" );
            break;
        default:
            for ( size_t i=0; i<node->n_children; i++ )
                generate_node ( node->children[i] );
            break;
    }
}


void
generate_function ( symbol_t *function )
{

    // current_function = function;
    printf ( "_%s:\n", function->name );

    /* Save arguments in local stack frame */
    for (size_t  arg=MIN(6,function->nparms); arg>=1; arg-- )
        printf ( "\tpushq\t%s\n", record[arg-1] );

    // Save caller stack frame
    puts ( "\tpushq   %rbp" );
    puts ( "\tmovq    %rsp, %rbp" );

    /* Save arguments in local stack frame */
    //for ( size_t arg=1; arg<=MIN(6,function->nparms); arg++ )
    //    printf ( "\tpushq\t%s\n", record[arg-1] );
    for (size_t i = 0; i < tlhash_size(function->locals)-function->nparms; i++) {
        printf ( "\tpushq $0 /* local var no. %zu */\n", i);
    }
    //Align stack to 16 bytes
    if ( (tlhash_size(function->locals)&1) == 1 )
        puts ( "\tpushq\t$0 /* Stack padding for 16-byte alignment */" );
    generate_node ( function->node );
    //current_function = NULL;
}
