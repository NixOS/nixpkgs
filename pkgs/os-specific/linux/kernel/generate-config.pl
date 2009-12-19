# This script runs `make config' to generate a Linux kernel
# configuration file.  For each question (i.e. kernel configuration
# option), unless an override is provided, it answers "m" if possible,
# and otherwise uses the default answer (as determined by the default
# config for the architecture).  Overrides are read from the file
# $KERNEL_CONFIG, which on each line contains an option name and an
# answer, e.g. "EXT2_FS_POSIX_ACL y".  The script warns about ignored
# options in $KERNEL_CONFIG, and barfs if `make config' selects
# another answer for an option than the one provided in
# $KERNEL_CONFIG.

use strict;
use IPC::Open2;

my $debug = $ENV{'DEBUG'};
    
$SIG{PIPE} = 'IGNORE';

# Read the answers.
my %answers;
my %requiredAnswers;
open ANSWERS, "<$ENV{KERNEL_CONFIG}" or die;
while (<ANSWERS>) {
    chomp;
    s/#.*//;
    if (/^\s*([A-Za-z0-9_]+)(\?)?\s+(\S+)\s*$/) {
        $answers{$1} = $3;
        $requiredAnswers{$1} = 1 unless defined $2;
    } elsif (!/^\s*$/) {
        die "invalid config line: $_";
    }
}
close ANSWERS;

sub runConfig {

    # Run `make config'.
    my $pid = open2(\*IN, \*OUT, "make config SHELL=bash ARCH=$ENV{ARCH}");

    # Parse the output, look for questions and then send an
    # appropriate answer.
    my $line = ""; my $s;
    my %choices = ();

    my ($prevQuestion, $prevName);

    while (!eof IN) {
        read IN, $s, 1 or next;
        $line .= $s;

        #print STDERR "LINE: $line\n";

        if ($s eq "\n") {
            print STDERR "GOT: $line" if $debug;

            # Remember choice alternatives ("> 1. bla (FOO)" or " 2. bla (BAR)").
            if ($line =~ /^\s*>?\s*(\d+)\.\s+.*\(([A-Za-z0-9_]+)\)$/) {
                $choices{$2} = $1;
            }

            $line = "";
        }

        elsif ($line =~ /###$/) {
            # The config program is waiting for an answer.

            # Is this a regular question? ("bla bla (OPTION_NAME) [Y/n/m/...] ")
            if ($line =~ /(.*) \(([A-Za-z0-9_]+)\) \[(.*)\].*###$/) {
                my $question = $1; my $name = $2; my $alts = $3;
                my $answer = "";
                # Build everything as a module if possible.
                $answer = "m" if $alts =~ /\/m/;
                $answer = $answers{$name} if defined $answers{$name};
                print STDERR "QUESTION: $question, NAME: $name, ALTS: $alts, ANSWER: $answer\n" if $debug;
                print OUT "$answer\n";
                die "repeated question: $question" if $prevQuestion && $prevQuestion eq $question && $name eq $prevName;
                $prevQuestion = $question;
                $prevName = $name;
            }

            # Is this a choice? ("choice[1-N]: ")
            elsif ($line =~ /choice\[(.*)\]: ###$/) {
                my $answer = "";
                foreach my $name (keys %choices) {
                    $answer = $choices{$name} if ($answers{$name} || "") eq "y";
                }
                print STDERR "CHOICE: $1, ANSWER: $answer\n" if $debug;
                print OUT "$answer\n" if $1 =~ /-/;
            }
        
            # Some questions lack the option name ("bla bla [Y/n/m/...] ").
            elsif ($line =~ /(.*) \[(.*)\] ###$/) {
                print OUT "\n";
            }
            
            else {
                die "don't know how to answer this question: $line\n";
            }
        
            $line = "";
            %choices = ();
        }
    }

    close IN;
    waitpid $pid, 0;
}

# Run `make config' several times to converge on the desired result.
# (Some options may only become available after other options are
# set in a previous run.)
runConfig;
runConfig;

# Read the final .config file and check that our answers are in
# there.  `make config' often overrides answers if later questions
# cause options to be selected.
my %config;
open CONFIG, "<.config" or die;
while (<CONFIG>) {
    chomp;
    if (/^CONFIG_([A-Za-z0-9_]+)=(.*)$/) {
        $config{$1} = $2;
    } elsif (/^# CONFIG_([A-Za-z0-9_]+) is not set$/) {
        $config{$1} = "n";
    }
}
close CONFIG;

foreach my $name (sort (keys %answers)) {
    my $f = $requiredAnswers{$name} && $ENV{'ignoreConfigErrors'} ne "1"
        ? sub { die @_; } : sub { warn @_; };
    &$f("unused option: $name\n") unless defined $config{$name};
    &$f("option not set correctly: $name\n")
        if $config{$name} && $config{$name} ne $answers{$name};
}
