package EchoBin::Controller::Statuses;
use Mojo::Base 'Mojolicious::Controller';
use Mojo::Util qw/url_unescape/;

sub answer {
    my ($self) = @_;

    # Registering supported types of response
    # (coderef)
    my $check_formats = $self->supports_types(qw/txt html json xml/);

    # (str) : [ html | txt | json | ... ]
    my $route_type = $self->request_type();

    my $codes_list = quotemeta(url_unescape($self->stash->{status_code}));

    $codes_list =~ s/[^\d,]//g;
    
    my @codes = grep { m/\d\d\d/ && int($_) >= 100 && int($_) <= 599 } split ',', $codes_list;

    unless ( @codes ) {
        $self->res->code(400);

        $self->stash(
            response => {
                answer => 'Bad Request. Incorrect "status code" list argument.'
            }
        );

        return $self->render('layouts/answer', format => 'html');
    }

    my $status_code;
    if ( @codes > 1 ) {
        my $lower_limit = 0;
        my $upper_limit = scalar @codes;
        my $index = int(rand($upper_limit-$lower_limit)) + $lower_limit;

        $status_code = $codes[$index];
    } else {
        $status_code = $codes[0];
    }

    # (int) : [ 1 (fail) | 0 (success) ]
    unless ( $check_formats->($route_type) ) {
        $self->res->code($status_code);

        $self->stash(
            response => {
                echo => $status_code
            }
        );
    }

    return $self->render('layouts/answer', format => $route_type);
}

1;
__END__
