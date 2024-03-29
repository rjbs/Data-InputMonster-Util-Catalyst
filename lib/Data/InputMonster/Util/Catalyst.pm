use strict;
use warnings;
package Data::InputMonster::Util::Catalyst;
# ABSTRACT: InputMonster sources for common Catalyst sources

=head1 DESCRIPTION

This module exports a bunch of routines to make it easy to use
Data::InputMonster with Catalyst.  Each method, below, is also available as an
exported subroutine, through the magic of Sub::Exporter.

These sources will expect to receive the Catalyst object (C<$c>) as the
C<$input> argument to the monster's C<consume> method.

=cut

use Carp ();
use Sub::Exporter::Util qw(curry_method);
use Sub::Exporter -setup => {
  exports => {
    form_param    => curry_method,
    body_param    => curry_method,
    query_param   => curry_method,
    session_entry => curry_method,
  }
};

=method form_param

  my $source = form_param($field_name);

This source will look for form parameters (with C<< $c->req->params >>) with
the given field name.

=cut

sub form_param {
  my ($self, $field_name) = @_;
  sub {
    my $field_name = defined $field_name ? $field_name : $_[2]{field_name};
    return $_[1]->req->params->{ $field_name };
  }
}

=method body_param

  my $source = body_param($field_name);

This source will look for form parameters (with C<< $c->req->body_params >>)
with the given field name.

=cut

sub body_param {
  my ($self, $field_name) = @_;
  sub {
    my $field_name = defined $field_name ? $field_name : $_[2]{field_name};
    return $_[1]->req->body_params->{ $field_name };
  }
}

=method query_param

  my $source = query_param($field_name);

This source will look for form parameters (with C<< $c->req->query_params >>)
with the given field name.

=cut

sub query_param {
  my ($self, $field_name) = @_;
  sub {
    my $field_name = defined $field_name ? $field_name : $_[2]{field_name};
    return $_[1]->req->query_params->{ $field_name };
  }
}

=method session_entry

  my $source = session_entry($locator);

This source will look for an entry in the session for the given locator, using
the C<dig> utility from L<Data::InputMonster::Util>.

=cut

sub session_entry {
  my ($self, $locator) = @_;

  require Data::InputMonster::Util;
  my $digger = Data::InputMonster::Util->dig($locator);

  return sub {
    my ($monster, $input, $arg) = @_;
    $monster->$digger($input->session, $arg);
  };
}

q{$C IS FOR CATALSYT, THAT'S GOOD ENOUGH FOR ME};
