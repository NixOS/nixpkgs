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

sub addToWorkSetExts {
    my $base = shift;
    foreach my $ext (@_) {
        push @workset, "$base$ext";
    }
}

push @workset, $root;

while (scalar @workset > 0) {

    my $fn = pop @workset;
    next if (defined $doneset{$fn});

    $doneset{$fn} = 1;

    next unless -e "$fn";
    
    
    # Print out the full path *and* its relative path to $root.
    
    die if substr($fn, 0, length $path) ne $path;
    my $relFN = substr($fn, (length $path) + 1);

    print OUT "$fn \"$relFN\"\n";

    
    # If this is a TeX file, recursively find include in $fn.
    next unless $fn =~ /.tex$/ or $fn =~ /.ltx$/; 
    open FILE, "< $fn" or die;
    
    while (<FILE>) {
	if (/\\input\{(.*)\}/) {
	    my $fn2 = $1;
            die "absolute path! $fn2" if substr($fn2, 0, 1) eq "/";
	    push @workset, "$path/$fn2";
	} elsif (/\\usepackage(\[.*\])?\{(.*)\}/) {
	    my $fn2 = $2;
            die "absolute path! $fn2" if substr($fn2, 0, 1) eq "/";
	    push @workset, "$path/$fn2.sty";
	} elsif (/\\documentclass(\[.*\])?\{(.*)\}/) {
	    my $fn2 = $2;
            die "absolute path! $fn2" if substr($fn2, 0, 1) eq "/";
	    push @workset, "$path/$fn2.cls";
	} elsif (/\\bibliographystyle\{(.*)\}/) {
	    my $fn2 = $1;
            die "absolute path! $fn2" if substr($fn2, 0, 1) eq "/";
	    push @workset, "$path/$fn2.bst";
	} elsif (/\\bibliography\{(.*)\}/) {
            foreach my $bib (split /,/, $1) {
                $bib =~ s/^\s+//; # remove leading / trailing whitespace
                $bib =~ s/\s+$//;
                push @workset, "$path/$bib.bib";
            }
	} elsif (/\\includegraphics(\[.*\])?\{(.*)\}/) {
	    my $fn2 = $2;
            die "absolute path! $fn2" if substr($fn2, 0, 1) eq "/";
            addToWorkSetExts("$path/$fn2", ".pdf", ".png", ".ps");
	} elsif (/\\pgfdeclareimage(\[.*\])?\{.*\}\{(.*)\}/) {
	    my $fn2 = $2;
            die "absolute path! $fn2" if substr($fn2, 0, 1) eq "/";
            addToWorkSetExts("$path/$fn2", ".pdf", ".png", ".jpg");
	} elsif (/\\pgfimage(\[.*\])?\{(.*)\}/) {
	    my $fn2 = $2;
            die "absolute path! $fn2" if substr($fn2, 0, 1) eq "/";
            addToWorkSetExts("$path/$fn2", ".pdf", ".png", ".jpg");
        }
        # !!! also support \usepackage
    }
    
    close FILE;
}

print OUT "]\n";
close OUT;
