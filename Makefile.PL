use ExtUtils::MakeMaker;
WriteMakefile(
 NAME => 'LEOCHARRE::Class2',
 VERSION_FROM => 'lib/LEOCHARRE/Class2.pm',
 PREREQ_PM => {
   'Test::Simple' => 0,
   Exporter => 0,
 }, 
);
