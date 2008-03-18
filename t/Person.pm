package Person;
use strict;
use LEOCHARRE::Class2;

__PACKAGE__->make_constructor();
__PACKAGE__->make_accessor_setget( 
   'name', 
   [ age => 19 ], 
   { speed => 348, pants => 27, hang => undef },   
);


1;

