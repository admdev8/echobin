use Mojo::Base -strict;

use Test::More;
use Test::Mojo;

use Mojolicious::Types;
use Mojo::Util qw/term_escape/;

my $t = Test::Mojo->new('EchoBin');
my $types = Mojolicious::Types->new;

my ($ext, $method);

# Метод указан большими буквами
$method = 'GET';
$ext = 'html';
$t->get_ok("/$method")
    ->status_is(200)
    ->header_is('Content-Type' => $types->type($ext))
    ->content_type_is($types->type($ext), 'Right content type is '. $ext)
    ->content_like(qr/$method/i);


# Метод указан маленькими буквами
$method = 'get';

$t->get_ok("/$method")
    ->status_is(200)
    ->header_is('Content-Type' => $types->type('html'))
    ->content_like(qr/$method/i);


# С указанием типа возвращаемого ответа через указание расширения в запросе
$ext = 'txt';
$t->get_ok("/$method.$ext")
    ->status_is(200)
    ->header_is('Content-Type' => $types->type($ext))
    ->content_type_is($types->type($ext), 'Right content type is '. $ext)
    ->content_like(qr/$method/i);

$ext = 'json';
$t->get_ok("/$method.$ext")
    ->status_is(200)
    ->header_is('Content-Type' => $types->type($ext))
    ->content_type_is($types->type($ext), 'Right content type is '. $ext)
    ->content_like(qr/$method/i);

$ext = 'html';
$t->get_ok("/$method.$ext")
    ->status_is(200)
    ->header_is('Content-Type' => $types->type($ext))
    ->content_type_is($types->type($ext), 'Right content type is '. $ext)
    ->content_like(qr/$method/i);

$ext = 'xml';
$t->get_ok("/$method.$ext")
    ->status_is(200)
    ->header_is('Content-Type' => $types->type($ext))
    ->content_type_is($types->type($ext), 'Right content type is '. $ext)
    ->content_like(qr/$method/i);



# С указанием типа возвращаемого ответа через заголовок Content-Type
$ext = 'txt';
$t->get_ok("/$method", {'Content-Type' => $types->type($ext)})
    ->status_is(200)
    ->header_is('Content-Type' => $types->type($ext))
    ->content_type_is($types->type($ext), 'Right content type is '. $ext)
    ->content_like(qr/$method/i);

$ext = 'json';
$t->get_ok("/$method", {'Content-Type' => $types->type($ext)})
    ->status_is(200)
    ->header_is('Content-Type' => $types->type($ext))
    ->content_type_is($types->type($ext), 'Right content type is '. $ext)
    ->content_like(qr/$method/i);

$ext = 'html';
$t->get_ok("/$method", {'Content-Type' => $types->type($ext)})
    ->status_is(200)
    ->header_is('Content-Type' => $types->type($ext))
    ->content_type_is($types->type($ext), 'Right content type is '. $ext)
    ->content_like(qr/$method/i);

$ext = 'xml';
$t->get_ok("/$method", {'Content-Type' => $types->type($ext)})
    ->status_is(200)
    ->header_is('Content-Type' => $types->type($ext))
    ->content_type_is($types->type($ext), 'Right content type is '. $ext)
    ->content_like(qr/$method/i);

$ext = 'html';
$t->get_ok("/$method", {'Content-Type' => $types->type($ext)})
    ->status_is(200)
    ->header_is('Content-Type' => $types->type($ext))
    ->content_type_is($types->type($ext), 'Right content type is '. $ext)
    ->content_like(qr/$method/i);


# С указанием разных типов возращаемого ответа через расширение файла и через заголовок Content-Type
# Заметка: Приоритет типу ответа, отдается указанному через расширение в запросе
# Причина: Конечный пользователь мог забыть убрать заголовок Content-Type
$ext = 'txt';
$t->get_ok("/$method.$ext", {'Content-Type' => $types->type('html')})
    ->status_is(200)
    ->header_is('Content-Type' => $types->type($ext))
    ->content_like(qr/$method/i);

$ext = 'json';
$t->get_ok("/$method.$ext", {'Content-Type' => $types->type('xml')})
    ->status_is(200)
    ->header_is('Content-Type' => $types->type($ext))
    ->content_like(qr/$method/i);

$ext = 'html';
$t->get_ok("/$method.$ext", {'Content-Type' => $types->type('txt')})
    ->status_is(200)
    ->header_is('Content-Type' => $types->type($ext))
    ->content_like(qr/$method/i);

$ext = 'xml';
$t->get_ok("/$method.$ext", {'Content-Type' => $types->type('json')})
    ->status_is(200)
    ->header_is('Content-Type' => $types->type($ext))
    ->content_like(qr/$method/i);


# Разные заголовок и тип запроса
# Заметка: Результатом должена стать ошибка 400 Bad Request
# Причина: В такой ситуации непонятно, что именно хочет конечный пользователь
$method = 'post';
$ext = 'txt';
$t->get_ok("/$method.$ext", {'Content-Type' => $types->type($ext)})
    ->status_is(400)
    ->header_is('Content-Type' => $types->type($ext))
    ->content_like(qr/$method/i);

$ext = 'json';
$t->get_ok("/$method.$ext", {'Content-Type' => $types->type($ext)})
    ->status_is(400)
    ->header_is('Content-Type' => $types->type($ext))
    ->content_like(qr/$method/i);

$ext = 'html';
$t->get_ok("/$method.$ext", {'Content-Type' => $types->type($ext)})
    ->status_is(400)
    ->header_is('Content-Type' => $types->type($ext))
    ->content_like(qr/$method/i);

$ext = 'xml';
$t->get_ok("/$method.$ext", {'Content-Type' => $types->type($ext)})
    ->status_is(400)
    ->header_is('Content-Type' => $types->type($ext))
    ->content_like(qr/$method/i);

done_testing();
