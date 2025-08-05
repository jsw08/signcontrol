use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
  NAME => 'SignControl',
  VERSION => '1.0',
  EXE_FILES => ['signcontrol'],
  PREREQ_PM => {
    perl => '5.6.1',
    'Digest::CRC' => '0.18',
    'IO::Socket::INET' => '1.31',
  },
  INSTALLDIRS => 'site',
);
