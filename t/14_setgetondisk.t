



package AppThing;
use lib './lib';
use LEOCHARRE::Class2;
use Smart::Comments '###';
use strict;
__PACKAGE__->make_constructor;

__PACKAGE__->make_accessor_setget_ondisk_file(
   'abs_conf',
);

__PACKAGE__->make_accessor_setget_ondisk_dir({
     abs_misc => './t/misc',
     abs_tmp => undef,
});
__PACKAGE__->make_method_counter( 'loans' );
1;



use Test::Simple 'no_plan';
use strict;
use lib './lib';
use Smart::Comments '###';
use Cwd;


ok(1);

my $o1 = new AppThing;
ok $o1,' can instance, but as soon as we ask for the nonexistant dir.. dies..';

ok( ! eval { $o1->abs_misc });





mkdir './t/misc';
-d './t/misc' or die;
my $o = new AppThing;
ok($o,'can instance regardless');






# DIR

ok !$o->abs_tmp,'abs tmp undef, was not ondisk';

ok( !$o->abs_tmp('./t/blablabla'), 'setting bogus val returns undef');

mkdir './t/tmp';
ok( $o->abs_tmp('./t/tmp'),'setting val of existing dir is ok') or die; 

my $r = $o->abs_tmp;
my $c = cwd().'/t/tmp';

ok( $r eq $c,"package resolves to $r eq $c");



# FILE
ok ( ! $o->abs_conf,'abs conf returns nothing yet' );
ok !$o->abs_conf('./t/tmp.conf'), 'abs conf undef, was not ondisk';

ok( !$o->abs_conf('./t/blablabla.txt'), 'setting bogus val returns undef');

open(F, '>', './t/tmp.conf') or die;
print F 'content';
close F;

ok( $o->abs_conf('./t/tmp.conf'),'setting val of existing file is ok'); 

$r = $o->abs_conf;
$c = cwd().'/t/tmp.conf';

ok( $r eq $c,"package resolves to $r eq $c");



# METHOD COUNTER

ok( ! $o->loans );
ok( $o->loans(1) == 1 );
ok( $o->loans(10) == 11 );
ok( $o->loans == 11 );
ok( ! $o->loans(0) );


unlink $c;
rmdir './t/misc';
rmdir './t/tmp';
