# This -*- perl -*- script writes the Makefile for File-Rsync

use 5.004;
use ExtUtils::MakeMaker;
use Config;

$NAME         = 'File::Rsync';
$DISTNAME     = 'File-Rsync';
$VERSION_FROM = 'Rsync.pm';
$AUTHOR       = 'Lee Eakin <leakin@dfw.nostrum.com>';
$ABSTRACT     = 'Wrapper module for rsync(1) http://rsync.samba.org/';

WriteMakefile(
      VERSION_FROM   => $VERSION_FROM,
      NAME           => $NAME,
      DISTNAME       => $DISTNAME,
      AUTHOR         => $AUTHOR,
      ABSTRACT       => $ABSTRACT,
      PREREQ_PM      => { 'Scalar::Util' => 0 },
      PL_FILES       => { 'makepm.PL' => 'config.pm' },
      PM             => { 'Rsync.pm'  => '$(INST_LIB)/File/Rsync.pm',
     			  'config.pm' => '$(INST_ARCHLIB)/File/Rsync/Config.pm' },
      dist           => { COMPRESS => 'gzip', SUFFIX => 'gz' },
      realclean      => { FILES => 'config.pm' },
);

