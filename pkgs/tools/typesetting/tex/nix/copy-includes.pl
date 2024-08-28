use strict;
use File::Basename;

sub createDirs;
sub createDirs {
    my $path = shift;
    return unless $path =~ /^(.*)\/([^\/]*)$/;
    my $dir = $1;
    return if -d $dir;
    return if -e $dir;
    createDirs $dir;
    mkdir $dir or die "cannot create directory `$dir'";
}

my $maxParents = 0;
for (my $n = 0; $n < @ARGV; $n += 2) {
    my $fullPath = $ARGV[$n];
    my $relPath = $ARGV[$n + 1];
    my $parents = 0;
    foreach my $comp (split /\//, $relPath) {
        $parents++ if ($comp eq "..") 
    }
    $maxParents = $parents if $parents > $maxParents;
}

my $startDir = "./";
for (my $n = 0; $n < $maxParents; $n++) {
    $startDir .= "dotdot/";
    mkdir "$startDir" or die "cannot create directory `$startDir': $!";
}

chdir $startDir or die;

for (my $n = 0; $n < @ARGV; $n += 2) {
    my $fullPath = $ARGV[$n];
    my $relPath = $ARGV[$n + 1];

    createDirs $relPath;
        
    symlink $fullPath, $relPath or die "cannot create symlink `$relPath'";
}

print "$startDir\n";
