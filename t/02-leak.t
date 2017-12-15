#!perl -T
use 5.008;
use strict;
use warnings FATAL => 'all';

use constant HAS_LEAKTRACE => eval{ require Test::LeakTrace };
use Test::More HAS_LEAKTRACE ? (tests => 4) : (skip_all => 'require Test::LeakTrace');
use Test::LeakTrace;

BEGIN { use_ok('AVLTree'); }

sub cmp_f {
  my ($i1, $i2) = @_;

  return $i1<$i2?-1:($i1>$i2)?1:0;
}

no_leaks_ok {
  my $tree = AVLTree->new(\&cmp_f);
} 'Empty tree';

no_leaks_ok {
  my $tree = AVLTree->new(\&cmp_f);
  map { $tree->insert($_) } qw/10 20 30 40 50 25/;
} 'Non-empty tree';

no_leaks_ok {
  my $tree = AVLTree->new(\&cmp_f);
  map { $tree->insert($_) } qw/10 20 30 40 50 25/;

  my $query = 30;
  my $result = $tree->find($query);
} 'After querying';

diag( "Testing memory leaking AVLTree $AVLTree::VERSION, Perl $], $^X" );
