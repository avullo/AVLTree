#ifndef AVLTREE_H
#define AVLTREE_H

/*
  AVL balanced tree library

    > Created (Julienne Walker): June 17, 2003
    > Modified (Julienne Walker): September 24, 2005

  This code is in the public domain. Anyone may
  use it or change it in any way that they see
  fit. The author assumes no responsibility for 
  damages incurred through use of the original
  code or any variations thereof.

  It is requested, but not required, that due
  credit is given to the original author and
  anyone who has modified the code through
  a header comment, such as this one.
*/
#ifdef __cplusplus
#include <cstddef>

using std::size_t;

extern "C" {
#else
#include <stddef.h>
#endif

#include <EXTERN.h>
#include <perl.h>

/* Opaque types */
typedef struct avltree avltree_t;
typedef struct avltrav avltrav_t;

/* User-defined item handling */
typedef int   (*cmp_f) ( SV *p1, SV *p2 );
typedef SV *(*dup_f) ( SV* p );
typedef void  (*rel_f) ( SV* p );

/* AVL tree functions */
avltree_t     *avltree_new ( cmp_f cmp, dup_f dup, rel_f rel );
void           avltree_delete ( avltree_t *tree );
SV            *avltree_find ( avltree_t *tree, SV *data );
int            avltree_insert ( avltree_t *tree, SV *data );
int            avltree_erase ( avltree_t *tree, SV *data );
size_t         avltree_size ( avltree_t *tree );

/* Traversal functions */
avltrav_t     *avltnew ( void );
void           avltdelete ( avltrav_t *trav );
void          *avltfirst ( avltrav_t *trav, avltree_t *tree );
void          *avltlast ( avltrav_t *trav, avltree_t *tree );
void          *avltnext ( avltrav_t *trav );
void          *avltprev ( avltrav_t *trav );

#ifdef __cplusplus
}
#endif

#endif /* AVLTREE_H */
