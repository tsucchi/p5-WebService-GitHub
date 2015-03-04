# NAME

WebService::GitHub - Web API Client for GitHub/GHE

# SYNOPSIS

    use WebService::GitHub;
    my $gh = WebService->

# DESCRIPTION

WebService::GitHub is Web API Client for GitHub/GHE. This module provides simple get/post/put/delete interface to call APIs and decode response JSON to Perl hashref.

# METHODS

## $instance = $class->new( token => 'your API token', base\_uri => 'https://your\_ghe\_server.com/api/v3' )

create instance. base\_uri is optional (default is https://github.com/api/v3)

## $response\_href = $self->get($end\_point, $query\_param\_href)

call API using GET request

## $response\_href = $self->post($end\_point, $data\_href)

call API using POST request

## $response\_href = $self->put($end\_point, $data\_href)

call API using PUT request

## $response\_href = $self->delete($end\_point)

call API using DELETE request

# SEE ALSO

https://developer.github.com/v3/enterprise/

# LICENSE

Copyright (C) Takuya Tsuchida.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# AUTHOR

Takuya Tsuchida <tsucchi@cpan.org>
