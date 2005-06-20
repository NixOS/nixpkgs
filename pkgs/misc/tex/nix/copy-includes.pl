use strict;
use File::Basename;

sub createDirs;
sub createDirs {
    my $path = shift;
    return unless $path =~ /^(.*)\/([^\/]*)$/;
    return if -d $1;
    createDirs $1;
    mkdir $1 or die "cannot create directory `$1'";
}

for (my $n = 0; $n < @ARGV; $n += 2) {
    my $fullPath = $ARGV[$n];
    my $relPath = $ARGV[$n + 1];

    createDirs $relPath;
        
    symlink $fullPath, $relPath or die "cannot create symlink `$relPath'";
}
