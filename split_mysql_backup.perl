#!/usr/bin/perl -w
#
# splitmysqldump - split mysqldump file into per-database dump files.

use strict;
use warnings;

my $dbfile;
my $dbname = q{};
my $header = q{};

while (<>) {

    # Beginning of a new database section:
    # close currently open file and start a new one
    if (m/-- Current Database\: \`([-\w]+)\`/) {
    if (defined $dbfile && tell $dbfile != -1) {
        close $dbfile or die "Could not close file!"
    } 
    $dbname = $1;
    open $dbfile, ">>", "$1_dump.sql" or die "Could not create file!";
    print $dbfile $header;
    print "Writing file $1_dump.sql ...\n";
    }

    if (defined $dbfile && tell $dbfile != -1) {
    print $dbfile $_;
    }

    # Catch dump file header in the beginning
    # to be printed to each separate dump file.  
    if (! $dbname) { $header .= $_; }
}
close $dbfile or die "Could not close file!"w
