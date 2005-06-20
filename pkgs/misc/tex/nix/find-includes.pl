use strict;
use File::Basename;

my $root = $ENV{"rootFile"};
my $out = $ENV{"out"};

open OUT, ">$out" or die;
print OUT "[\n";

# We search for files relative to the root file.  TODO: search
# relative to the paths in $TEXINPUTS.
die unless substr($root, 0, 1) eq "/";
my ($x, $path, $y) = fileparse($root);

$path =~ s/\/$//;

my @workset = ();
my %doneset = ();

push @workset, $root;

while (scalar @workset > 0) {

    my $fn = pop @workset;
    next if (defined $doneset{$fn});

    $doneset{$fn} = 1;
    
    if (!open FILE, "< $fn") {
	print STDERR "(cannot open $fn, ignoring)\n";
	next;
    };

    
    # Print out the full path *and* its relative path to $root.
    
    die if substr($fn, 0, length $path) ne $path;
    my $relFN = substr($fn, (length $path) + 1);

    print OUT "$fn \"$relFN\"\n";

    
    # Recursively find include in $fn.
    while (<FILE>) {
	if (/\\input\{(.*)\}/) {
	    my $fn2 = $1;
            die "absolute path! $fn2" if substr($fn2, 0, 1) eq "/";
	    push @workset, $path . "/" . $fn2;
	} elsif (/\\documentclass(\[.*\])?\{(.*)\}/) {
	    my $fn2 = $2;
            die "absolute path! $fn2" if substr($fn2, 0, 1) eq "/";
	    push @workset, $path . "/" . $fn2 . ".cls";
	}
        # !!! also support \usepackage
    }
    
    close FILE;
}

print OUT "]\n";
close OUT;
