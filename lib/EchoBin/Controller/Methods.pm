package EchoBin::Controller::Methods;
use Mojo::Base 'Mojolicious::Controller';

sub answer {
    my ($self) = @_;

    # Registering supported types of response
    # (coderef)
    my $check_formats = $self->supports_types(qw/txt html json xml/);

    # (str) : [ html | txt | json | ... ]
    my $route_type = $self->request_type();

    # (str) : [ GET | POST | PUT | ... ]
    my $request_method = $self->req->method;

    my $route_method = $self->stash->{method_name};

    # Compare server request method with route method
    if ( lc $route_method ne lc $request_method ) {
        $self->res->code(400);
        
        $self->stash(
            response => {
                answer => 'Bad request. Got method "'. $request_method .'" but requested method "'. $route_method .'".'
            }
        );

        return $self->render('layouts/answer', format => 'html');
    }

    # (int) : [ 1 (fail) | 0 (success) ]
    unless ( $check_formats->($route_type) ) {
        $self->stash(
            response => {
                echo => $request_method
            }
        );
    }

    return $self->render('layouts/answer', format => $route_type);
}

1;
__END__
