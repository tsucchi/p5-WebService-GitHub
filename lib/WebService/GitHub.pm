package WebService::GitHub;
use 5.008001;
use strict;
use warnings;

our $VERSION = "0.01";

use Mouse;
use LWP::UserAgent;
use URI;
use Carp ();
use JSON qw(decode_json encode_json);

my $base_uri = 'https://github.com/api/v3';

has 'token' => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
);

has 'timeout' => (
    is      => 'ro',
    isa     => 'Int',
    default => 10,
);

has 'base_uri' => (
    is      => 'ro',
    isa     => 'Str',
    default => $base_uri,
);

has 'ua' => (
    is       => 'ro',
    isa      => 'LWP::UserAgent',
    lazy     => 1,
    required => 1,
    default  => sub {
        my ($self) = @_;
        LWP::UserAgent->new( timeout => $self->timeout );
    },
);

no Mouse;

sub _request {
    my ($self, $method, $end_point, $data_json, @additional_header) = @_;

    my $ua = $self->ua;
    my $uri = $self->base_uri . $end_point;
    my $req = HTTP::Request->new($method, $uri, ['Authorization' => "token " . $self->token, @additional_header], $data_json);
    my $res = $ua->request($req);
    unless ( $res->is_success ) {
        Carp::croak $res->status_line . $res->content;
    }
    return if ( $res->code eq '204' );# No Content
    return decode_json($res->content);
}

sub get {
    my ($self, $end_point, $query_param_href) = @_;

    if ( defined $query_param_href ) {
        my $uri = URI->new();
        $uri->query_form( %{ $query_param_href } );
        $end_point .= $uri->as_string;
    }
    return $self->_request('GET', $end_point);
}

sub post {
    my ($self, $end_point, $data_href) = @_;
    my $data_json = encode_json($data_href);
    my @additional_header = ( 'Content-Type' => 'application/json' );
    return $self->_request('POST', $end_point, $data_json, @additional_header);
}

sub put {
    my ($self, $end_point, $data_href) = @_;
    my $data_json = encode_json($data_href);
    my @additional_header = ( 'Content-Type' => 'application/json' );
    return $self->_request('PUT', $end_point, $data_json, @additional_header);
}

sub delete {
    my ($self, $end_point) = @_;
    return $self->_request('DELETE', $end_point);
}




1;
__END__

=encoding utf-8

=head1 NAME

WebService::GitHub - Web API Client for GitHub/GHE

=head1 SYNOPSIS

    use WebService::GitHub;
    my $gh = WebService::GitHub->new(
        token    => 'your api token',
    );
    my $result = $gh->get('/repos/tsucchi/p5-WebService-GitHub/pulls/1');


=head1 DESCRIPTION

WebService::GitHub is Web API Client for GitHub/GHE. This module provides simple get/post/put/delete interface to call APIs and decode response JSON to Perl hashref.

=head1 METHODS

=head2 $instance = $class->new( token => 'your API token', base_uri => 'https://your_ghe_server.com/api/v3' )

create instance. base_uri is optional (default is https://github.com/api/v3) and If you use GHE, 

=head2 $response_href = $self->get($end_point, $query_param_href)

call API using GET request

=head2 $response_href = $self->post($end_point, $data_href)

call API using POST request

=head2 $response_href = $self->put($end_point, $data_href)

call API using PUT request

=head2 $response_href = $self->delete($end_point)

call API using DELETE request

=head1 SEE ALSO

https://developer.github.com/v3/enterprise/

=head1 LICENSE

Copyright (C) Takuya Tsuchida.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

Takuya Tsuchida E<lt>tsucchi@cpan.orgE<gt>

=cut

