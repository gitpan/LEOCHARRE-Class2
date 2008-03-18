package LEOCHARRE::Class2;
use strict;
no strict 'refs';
use vars qw($VERSION @ISA @EXPORT);
use Exporter;
@ISA = qw/Exporter/;
@EXPORT = qw(make_constructor make_accessor_setget);
$VERSION = sprintf "%d.%02d", q$Revision: 1.2 $ =~ /(\d+)/g;


sub make_constructor {
   my $class = shift;
   *{"$class\::new"} = sub {
      my ($class,$self) = @_;
      $self||={};
      bless $self, $class;
      return $self;
   };
}


sub make_accessor_setget {
   my $class = shift;
   defined $class or die;
   
   my ($arg, $ref, $name, $default_value);
   
   METHOD : while (scalar @_){
      $arg = shift;      
      defined $arg or die('1.arguments must be scalars, array refs, or hash refs, not undef or false');    
      
      if ( $ref = ref $arg ){
      
         if ( $ref eq 'ARRAY' ){
            ($name, $default_value) = ($arg->[0], $arg->[1]);
            _make($class, $name, $default_value);
            next METHOD;
         }
         
         elsif ( $ref eq 'HASH' ){
            while( ($name, $default_value) = each %$arg ){
               _make($class, $name, $default_value);
            }
            next METHOD;
         }
         
         else {
            die('2.arguments must be scalars, array refs, or hash refs, not undef or false');
         }
      }

      # else not a ref

      _make($class,$arg);
      
   }

   


   sub _make {
      my($class,$name,$default) = @_;
      my $namespace = "$class\::$name";      
      ${$namespace} = $default_value; # may be undef, that's ok
      *{$namespace} = sub {
         my ($self,$val) = @_;
      
         if( defined $val ){ # store it in object instance only
            $self->{$name} = $val;
         }

         unless( defined $self->{$name} ){
                     
            if( defined ${$namespace} ){# check if it's defined in the class default
               $self->{$name} = ${$namespace};
            }
         }
         return $self->{$name}; # may still be undef, that's ok
      }; 
   }   
}



#sub make_accessor_errstr {
#   my $class = shift;
#   my $namespace = "$class\::errstr";
#}



1;



__END__

=pod

=head1 NAME

LEOCHARRE::Class2

=head1 METHODS

=head2 make_constructor()

   __PACKAGE__->make_constructor();

creates normal blessed object from optional hashref


=head2 make_accessor_setget()

argument is name of accessor to create in class.
can provide a list of names.

optionally, if the argument is an array ref, the second element should be the default value to set.

This example creates 'model', 'year' and 'make' setget methods in the current class:

   __PACKAGE__->make_accessor_setget(
      'model', 
      'make', 
      'year',
   );

This is example is the same but sets defaults for make and year

   __PACKAGE__->make_accessor_setget(
      'model', 
      [ 'make' => 'toyota' ], 
      [ 'year' => '1999'   ],
   );

If those values are passed to the constructor or via method, they change..


   my $o = Thing->new({ make => 'ford' });
   $o->year(2001);   # changes to 2001
   $o->year;         # returns 2001
   $o->model;        # returns undef
   $o->make;         # returns ford
   

You can also pass a hashref as argument to make setget methods, keys are names, vals are 
the default values..

   __PACKAGE__->make_accessor_setget({
      model => undef,
      make  => 'toyota',
      year  => '1999',
   });





=head3 How the method created works

This checks for a value in order of 
1) in (a)rgument to method
1) in (o)bject instance data (self)
2) in (c)lass package

If a value is provided, the object's data is changed, not the class.
If no value is provided, we return the object's data, if none, the class, if none, undef.

This example creates an object setget accessor that defaults to the name jimmy, stored in the class.

   __PACKAGE__->make_accessor_setget(['name' => 'jimmy']);

Our class being named 'My::House', we now have

   &My::House::name
   $My::House::name

Value in object instance is stored in self
Thus, if you provide to the constructor a 'self' hashref that specifies a 'name', the method name 
would return that value.



