package AVLTree;

use 5.008;
use strict;
use warnings;

our $VERSION = '0.01';
our $ENABLE_DEBUG = 1;

require XSLoader;
XSLoader::load('AVLTree', $VERSION);

1; # End of AVLTree
__END__

=head1 NAME

AVLTree - The great new AVLTree!

=head1 VERSION

Version 0.01

=cut

=head1 SYNOPSIS

Quick summary of what the module does.

Perhaps a little code snippet.

    use AVLTree;

    my $foo = AVLTree->new();
    ...

=head1 DESCRIPTION


=head1 METHODS


=head1 SEE ALSO


=head1 AUTHOR

Alessandro Vullo, C<< <avullo at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-avltree at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=AVLTree>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc AVLTree


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker (report bugs here)

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=AVLTree>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/AVLTree>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/AVLTree>

=item * Search CPAN

L<http://search.cpan.org/dist/AVLTree/>

=back


=head1 ACKNOWLEDGEMENTS


=head1 LICENSE AND COPYRIGHT

Copyright 2017 Alessandro Vullo.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See L<http://dev.perl.org/licenses/> for more information.


=cut
