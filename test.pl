#!/usr/local/bin/perl -w

BEGIN { $|=1; print "1..6\n" }
END { print("not ok 1\n"),exit 1 unless $loaded }

use File::Rsync;
use strict;
use vars qw($loaded $fail);
$loaded=1;
$fail=0;
warn "\nNOTE: expect 'badoption' message for test 7\n\n";
print "ok 1\n";

unless (-x $File::Rsync::RsyncConfig{rsync_path}) {
   $fail++;
   print "not ok 2\n";
   warn "configured path to rsync binary ($File::Rsync::RsyncConfig{rsync_path}) does not exist or is not executable\n";
   exit 1;
}
print "ok 2\n";

system qw(rm -rf destdir);
# all in one
{
   my $rs=File::Rsync->new(archive => 1,
         src => 'blib', dest => 'destdir');
   unless ($rs) {
      print "not ";
   } else {
      my $ret=$rs->exec;
      ($ret == 1 && $rs->status == 0 && ! $rs->err) || ($fail++,print "not ");
   }
   print "ok 3\n";
}

system qw(rm -rf destdir);
# some in new, some in exec
{
   my $rs=File::Rsync->new(archive => 1);
   unless ($rs) {
      $fail++;
      print "not ";
   } else {
      my $ret=$rs->exec(src => 'blib', dest => 'destdir');
      ($ret == 1 && $rs->status == 0 && ! $rs->err) || ($fail++,print "not ");
   }
   print "ok 4\n";
}

system qw(rm -rf destdir);
# non-existant source
{
   my $rs=File::Rsync->new(archive => 1);
   unless ($rs) {
      $fail++;
      print "not ";
   } else {
      no strict;
      my $ret=$rs->exec(src => 'some-non-existant-path-name', dest => 'destdir');
         (@{$rs->err} >= 1
         && $rs->err->[0] =~ /\bNo such file or directory\b/i)
         || ($fail++,print "not ");
   }
   print "ok 5\n";
}

system qw(rm -rf destdir);
# non-existant destination
{
   my $rs=File::Rsync->new(archive => 1);
   unless ($rs) {
      $fail++;
      print "not ";
   } else {
      no strict;
      my $ret=$rs->exec(src => 'blib', dest => 'destdir/subdir');
      ($ret == 0
         && $rs->status != 0
         && @{$rs->err} > 0
         && ${$rs->err}[0] =~/\bNo such file or directory\b/i)
         || ($fail++,print "not ");
   }
   print "ok 6\n";
}

system qw(rm -rf destdir);
# invalid option
{
   my $rs=File::Rsync->new(archive => 1, badoption => 1);
   $rs && ($fail++,print "not ");
   print "ok 7\n";
}

system qw(rm -rf destdir);
exit 1 if $fail;
