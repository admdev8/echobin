package EchoBin;
use Mojo::Base 'Mojolicious';

has 'plugins_namespace' => __PACKAGE__.'::Plugin';

# This method will run once at server start
sub startup {
    my $self = shift;

    # Load configuration from hash returned by config file
    my $config = $self->plugin('Config');

    push @{ $self->plugins->namespaces }, $self->plugins_namespace;
    $self->plugin('RequestHelper');

    # Router
    my $r = $self->routes;

    # Normal route to controller
    $r->get('/')->to('example#welcome');

    $r->any('/:method_name', [
        method_name => qr/get|post|put|delete|patch|head/i,
    ])->to('Methods#answer', method_name => 'get');

    $r->any('/status/:status_code')->to('Statuses#answer', status_code => q{418});
}

1;
__END__
