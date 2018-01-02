#ifdef __cplusplus
extern "C" {
#endif

/* 
   From http://blogs.perl.org/users/nick_wellnhofer/2015/03/writing-xs-like-a-pro---perl-no-get-context-and-static-functions.html
   The perlxs man page recommends to define the PERL_NO_GET_CONTEXT macro before including EXTERN.h, perl.h, and XSUB.h. 
   If this macro is defined, it is assumed that the interpreter context is passed as a parameter to every function. 
   If it's undefined, the context will typically be fetched from thread-local storage when calling the Perl API, which 
   incurs a performance overhead.
   
   WARNING:
   
    setting this macro involves additional changes to the XS code. For example, if the XS file has static functions that 
    call into the Perl API, you'll get somewhat cryptic error messages like the following:

    /usr/lib/i386-linux-gnu/perl/5.20/CORE/perl.h:155:16: error: ‘my_perl’ undeclared (first use in this function)
    #  define aTHX my_perl

   See http://perldoc.perl.org/perlguts.html#How-do-I-use-all-this-in-extensions? for ways in which to avoid these
   errors when using the macro.

   One way is to begin each static function that invoke the perl API with the dTHX macro to fetch context. This is
   used in the following static functions.
   Another more efficient approach is to prepend pTHX_ to the argument list in the declaration of each static
   function and aTHX_ when each of these functions are invoked. This is used directly in the AVL tree library
   source code.
*/
#define PERL_NO_GET_CONTEXT
  
#ifdef ENABLE_DEBUG
#define TRACEME(x) do {						\
    if (SvTRUE(perl_get_sv("AVLTree::ENABLE_DEBUG", TRUE)))	\
      { PerlIO_stdoutf (x); PerlIO_stdoutf ("\n"); }		\
  } while (0)
#else
#define TRACEME(x)
#endif
  
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
  
#include "ppport.h"
  
#include "avltree.h"
  
#ifdef __cplusplus
}
#endif

typedef avltree_t AVLTree;

/* C-level callbacks required by the AVL tree library */

static SV* callback = (SV*)NULL;

static int svcompare(SV *p1, SV *p2) {
  /*
    This is one way to avoid the above mentioned error when 
    declaring the PERL_NO_GET_CONTEXT macro
  */
  dTHX; 
  
  int cmp;
  
  dSP;
  int count;

  //ENTER;
  //SAVETMPS;
  
  PUSHMARK(SP);
  XPUSHs(sv_2mortal(newSVsv(p1)));
  XPUSHs(sv_2mortal(newSVsv(p2)));
  PUTBACK;
  
  /* Call the Perl sub to process the callback */
  count = call_sv(callback, G_SCALAR);

  SPAGAIN;

  if(count != 1)
    croak("Did not return a value\n");
  
  cmp = POPi;
  PUTBACK;

  //FREETMPS;
  //LEAVE;

  return cmp;
}

static SV* svclone(SV* p) {
  dTHX;       /* fetch context */
  
  return newSVsv(p);
}

void svdestroy(SV* p) {
  dTHX;       /* fetch context */
  
  SvREFCNT_dec(p);
}

/*====================================================================
 * XS SECTION                                                     
 *====================================================================*/

MODULE = AVLTree 	PACKAGE = AVLTree
  
AVLTree*
new( class, cmp_f )
  char* class
  SV*   cmp_f
  PROTOTYPE: $$
  CODE:
    TRACEME("Registering callback for comparison");
    if(callback == (SV*)NULL)
      callback = newSVsv(cmp_f);
    else
      SvSetSV(callback, cmp_f);
    
    TRACEME("Allocating AVL tree");
    RETVAL = avltree_new(svcompare, svclone, svdestroy);

    if(RETVAL == NULL) {
      warn("Unable to allocate AVL tree");
      XSRETURN_UNDEF;
    }

  OUTPUT:
    RETVAL

MODULE = AVLTree 	PACKAGE = AVLTreePtr

SV*
find(t, ...)
  AVLTree* t
  INIT:
    if(items < 2 || !SvOK(ST(1)) || SvTYPE(ST(1)) == SVt_NULL) {
      XSRETURN_UNDEF;
    }
  CODE:
    SV* result = avltree_find(aTHX_ t, ST(1));
    if(SvOK(result) && SvTYPE(result) != SVt_NULL) {
      /* WARN: if it's mortalised e.g. sv_2mortal(...)? returns "Attempt to free unreferenced scalar: SV" */
      RETVAL = newSVsv(result);
    } else
      XSRETURN_UNDEF;
  OUTPUT:
    RETVAL

int
insert(t, item)
  AVLTree* t
  SV* item
  PROTOTYPE: $$
  CODE:
    RETVAL = avltree_insert(t, item);
  OUTPUT:
    RETVAL

int
remove(t, item)
  AVLTree* t
  SV* item
  PROTOTYPE: $$
  CODE:
    RETVAL = avltree_erase(t, item);
  OUTPUT:
    RETVAL

int
size(t)
  AVLTree* t
  PROTOTYPE: $
  CODE:
    RETVAL = avltree_size(t);
  OUTPUT:
    RETVAL
    
void DESTROY(t)
  AVLTree* t
  PROTOTYPE: $
  CODE:
      TRACEME("Deleting AVL tree");
      avltree_delete(t);

  
