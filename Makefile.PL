use ExtUtils::MakeMaker;

WriteMakefile(
   NAME => 'LEOCHARRE::Class2',
   VERSION_FROM => 'lib/LEOCHARRE/Class2.pm',


   # gen /usr/bin/pmused by Wed Apr  9 05:26:24 EDT 2008 
   PREREQ_PM => {
      'Cwd'                               => '3.2701',
      'Exporter'                          => '5.58',
      'Smart::Comments'                   => '1.0.2',
      'Test::Simple'                      => '0.74',
   },


   EXE_FILES => [],
);


