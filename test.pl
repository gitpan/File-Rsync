#!/usr/local/bin/perl -w

BEGIN { $|=1; print "1..7\n" }
END { print "not ok 1\n" unless $loaded }

use File::Rsync;
use strict;
use vars qw($loaded);
$loaded=1;
print STDERR "\nNOTE: expect 'badoption' message for test 7\n\n";
print "ok 1\n";

system qw(rm -rf destdir);
# perl-style, all in one
{
   my $rs=File::Rsync->new({archive => 1,
         src => 'blib', dest => 'destdir'});
   unless ($rs) {
      print "not ";
   } else {
      my $ret=$rs->exec;
      $ret == 1 && $rs->status == 0 && ! $rs->err || print "not ";
   }
   print "ok 2\n";
}

system qw(rm -rf destdir);
# perl-style, some in new, some in exec
{
   my $rs=File::Rsync->new({archive => 1});
   unless ($rs) {
      print "not ";
   } else {
      my $ret=$rs->exec({src => 'blib', dest => 'destdir'});
      $ret == 1 && $rs->status == 0 && ! $rs->err || print "not ";
   }
   print "ok 3\n";
}

system qw(rm -rf destdir);
# mixed arg types
{
   my $rs=File::Rsync->new({archive => 1}, 'blib', 'destdir');
   unless ($rs) {
      print "not ";
   } else {
      my $ret=$rs->exec;
      $ret == 1 && $rs->status == 0 && ! $rs->err || print "not ";
   }
   print "ok 4\n";
}

system qw(rm -rf destdir);
# non-existant source
{
   my $rs=File::Rsync->new({archive => 1});
   unless ($rs) {
      print "not ";
   } else {
      my $ret=$rs->exec('some-non-existant-path-name','destdir');
      # odd: on Solaris $ret == 0, $rs->status == 11
      #    but on Linux $ret == 1, $rs->status == 0
         @{$rs->err} == 1
         && ${$rs->err}[0] =~ /^\S+\s*:\s+No such file or directory$/
         || print "not ";
   }
   print "ok 5\n";
}

system qw(rm -rf destdir);
# non-existant destination
{
   my $rs=File::Rsync->new({archive => 1});
   unless ($rs) {
      print "not ";
   } else {
      my $ret=$rs->exec('blib','destdir/subdir');
      $ret == 0
         && $rs->status != 0
         && @{$rs->err} > 0
         && ${$rs->err}[0] =~/^mkdir\s+\S+\s*:\s+No such file or directory\b/
         || print "not ";
   }
   print "ok 6\n";
}

system qw(rm -rf destdir);
# invalid option
{
   my $rs=File::Rsync->new({archive => 1, badoption => 1});
   $rs && print "not ";
   print "ok 7\n";
}

system qw(rm -rf destdir);
