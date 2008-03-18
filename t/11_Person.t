use Test::Simple 'no_plan';
use strict;
use lib './t';
use lib './lib';
use Person;
ok(1);

my $f = Person->new({ hang => 'luster' });
ok($f, 'object instanced');

ok( ! $f->name );
ok( $f->hang eq  'luster');
ok( $f->pants == 27 );
ok( $f->speed );
ok( $f->age == 19 );









