package LEOCHARRE::Class2;
use strict;
no strict 'refs';
use vars qw($VERSION @ISA @EXPORT);
use Exporter;
@ISA = qw/Exporter/;
@EXPORT = qw(make_constructor make_accessor_setget);
$VERSION = sprintf "%d.%02d", q$Revision: 1.3 $ =~ /(\d+)/g;
#use Smart::Comments '###';

sub make_constructor {
   my $class = shift;
   ### $class
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
   
   my ($arg);
   
   METHOD : while (scalar @_){
      $arg = shift;      
      defined $arg or die('1.arguments must be scalars, array refs, or hash refs, not undef or false');    
      
      ### $arg
      if ( my $ref = ref $arg ){
         
         if ( $ref eq 'ARRAY' ){
            my ($name, $default_value) = ($arg->[0], $arg->[1]);
            _make($class, $name, $default_value);
            ### array
            ### $name
            ### $default_value
            next METHOD;
         }
         
         elsif ( $ref eq 'HASH' ){
            ### hash
            while( my ($name, $default_value) = each %$arg ){
               _make($class, $name, $default_value);               
               ### $name
               ### $default_value
            }
            next METHOD;
         }
         
         else {
            die("2.arguments must be scalars, array refs, or hash refs, not undef or false or '$ref'");
         }
      }

      # else not a ref

      _make($class,$arg);
      
      ### not ref
      ### $arg
   }

   


  
}

   sub _make {
      my($_class,$_name,$_default_value) = @_;

      my $namespace = "$_class\::$_name";      

      #if (defined $_default_value ){
      #   ${$namespace} = $_default_value;
      #}


      *{$namespace} = sub {
         my $self = shift;
         my ($val) = @_;
      
         if( defined $val ){ # store it in object instance only
            $self->{$_name} = $val;
         }

         # if the key does not exist and we DO have a default in the class...
         if( ! exists $self->{$_name} ){

            if( defined $_default_value ){ # if in class data

               # BUT, if it is a ref, COPY it

               # IS A REF:
               if ( my $ref = ref $_default_value ){

                  if ($ref eq 'ARRAY'){
                     ### array
                     $self->{$_name} = [];
                     for(@$_default_value){
                        push @{$self->{$_name}}, $_;
                     }
                  }

                  elsif( $ref eq 'HASH' ){
                     ### hash
                     #my %h = %{${$namespace}};
                     $self->{$_name} = {};
                     for(keys %$_default_value){ 
                        $self->{$_name}->{$_} = $_default_value->{$_};
                     }
                  }

                  elsif ( $ref eq 'SCALAR' ){
                     ### scalar
                     $self->{$_name} = $$_default_value;                  
                  }
                  else {
                     die("dont know how to use '$ref' ref as a default");
                  }
               }


               # IS NOT A REF:
               else {
                  $self->{$_name} = $_default_value;
               }
            }
            
         }
         return $self->{$_name}; # may still be undef, that's ok
      }; 
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

=head1 CAVEATS

=item class wide defaults

Please note, if you set a default value to be an anon ref, this is indeed set for the whole class.
BUT, when an object is intanced, the instance data will actually hold a COPY of the value.

For example:

   Neighborhood->make_accessor_setget([ houses => ['green','red'] ]);

Would normally cause all object instances of Neighborhood to refer to the same houses anon array ref.
We don't want that, we just want to use that as a default.
So the above will actually result in

$Neighborhood::houses = $your_ref

Don't think too hard about it.

=item resetting methods that had defaults

If you provide a default and then you set it to undef, we do not load the defaults again..

   __PACKAGE__->make_accessor_setget([ name => 'leo' ]);

   $self->{name} = undef;

   $self->name; # returns undef
   
Basically it means that if the blessed hashref does not have the method data key, THEN we do
attempt to load a default.
This is so you don't get unexpected results.






