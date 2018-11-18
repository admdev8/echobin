package EchoBin::Plugin::RequestHelper;
use Mojo::Base 'Mojolicious::Plugin';
use Mojolicious::Types;

my $DEFAULT_FORMAT = 'html';

sub register {
    my ($self, $app) = @_;

    $app->helper('request_type' => \&_request_type);
    $app->helper('supports_types' => \&_supports_types);
}

sub _request_type {
    my ($self) = @_;
    
    my $types = Mojolicious::Types->new;

    # Получение заголовка Content-Type и формата роута
    my $route_type = $self->stash->{format};
    my $request_type = $self->req->headers->content_type;
    
    # Определяем формат роута следующим образом:
    # - по формату запроса
    # - по заголовку запроса
    # - по умолчанию
    # Ошибка: Тип ответа определить не удалось
    if ( !$route_type && $request_type ) {
        $request_type = (split ';', $request_type)[0];
        $route_type = @{$types->detect($request_type)}[0];

        $route_type = 'html' if $route_type =~ /s?html?/;
    }
    elsif ( !$route_type && !$request_type ) {
        $route_type = $DEFAULT_FORMAT
    }

    return $route_type;
}

sub _supports_types {
    my ($self, @formats) = @_;

    my %register;

    $register{$_} = 1 for @formats;

    return sub {
        my ($format) = @_;

        if ( ! defined $register{$format} ) {
            $self->res->code(404);

            $self->stash->{response} = {
                'answer' => 'Not found. The format "'. $format .'" not found.'
            };

            return 1;
        }

        return 0;
    }
}

1;
__END__
