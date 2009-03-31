use ExtUtils::MakeMaker;

WriteMakefile(
   NAME => 'LEOCHARRE::Class2',
   VERSION_FROM => 'lib/LEOCHARRE/Class2.pm',
   

   # gen /usr/bin/pmused by Tue Mar 31 11:40:00 EDT 2009 
   PREREQ_PM => {
      'Carp'                              => '1',
      'Cwd'                               => '3',
      'Exporter'                          => '5',
      'Smart::Comments'                   => '1',
      'Test::Simple'                      => '0',
   },

   
   LICENSE => 'perl',
   
   
   
   EXE_FILES => [],
);


