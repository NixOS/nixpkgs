#! /usr/bin/perl -w

use strict;
use Cwd;

my $selfdir = $ENV{"out"};
mkdir "$selfdir", 0755 || die "error creating $selfdir";

# For each activated package, create symlinks.

sub createLinks {
    my $srcdir = shift;
    my $dstdir = shift;

    my @srcfiles = glob("$srcdir/*");

    foreach my $srcfile (@srcfiles) {
        my $basename = $srcfile;
        $basename =~ s/^.*\///g; # strip directory
        my $dstfile = "$dstdir/$basename";
	if ($srcfile =~ /\/envpkgs$/) {
	} elsif (-d $srcfile) {
            # !!! hack for resolving name clashes
            if (!-e $dstfile) {
                mkdir $dstfile, 0755 || 
                    die "error creating directory $dstfile";
            }
            -d $dstfile or die "$dstfile is not a directory";
            createLinks($srcfile, $dstfile);
        } elsif (-l $dstfile) {
            my $target = readlink($dstfile);
            die "collission between $srcfile and $target";
        } else {
#            print "linking $dstfile to $srcfile\n";
            symlink($srcfile, $dstfile) ||
                die "error creating link $dstfile";
        }
    }
}

my %done;

sub addPkg {
    my $pkgdir = shift;

    return if (defined $done{$pkgdir});
    $done{$pkgdir} = 1;

    print "merging $pkgdir\n";

    createLinks("$pkgdir", "$selfdir");

#    if (-f "$pkgdir/envpkgs") {
#	my $envpkgs = `cat $pkgdir/envpkgs`;
#	chomp $envpkgs;
#	my @envpkgs = split / +/, $envpkgs;
#	foreach my $envpkg (@envpkgs) {
#	    addPkg($envpkg);
#	}
#    }
}


foreach my $name (keys %ENV) {

    next unless ($name =~ /^act.*$/);

    my $pkgdir = $ENV{$name};

    addPkg($pkgdir);
}
