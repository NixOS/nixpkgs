#! @perl@

use strict;
use POSIX;
use File::Path;
use File::Slurp;
use Fcntl ':flock';
use Getopt::Long qw(:config gnu_getopt);
use Cwd 'abs_path';
use Time::HiRes;

my $su = "@su@";

# Ensure a consistent umask.
umask 0022;

# Ensure $NIXOS_CONFIG is not set.
$ENV{"NIXOS_CONFIG"} = "";

# Parse the command line.

sub showHelp {
    print <<EOF;
Usage: nixos-container list
       nixos-container create <container-name>
         [--nixos-path <path>]
         [--system-path <path>]
         [--config <string>]
         [--config-file <path>]
         [--flake <flakeref>]
         [--ensure-unique-name]
         [--auto-start]
         [--bridge <iface>]
         [--port <port>]
         [--host-address <string>]
         [--local-address <string>]
       nixos-container destroy <container-name>
       nixos-container start <container-name>
       nixos-container stop <container-name>
       nixos-container terminate <container-name>
       nixos-container status <container-name>
       nixos-container update <container-name>
         [--config <string>]
         [--config-file <path>]
         [--flake <flakeref>]
         [--nixos-path <path>]
       nixos-container login <container-name>
       nixos-container root-login <container-name>
       nixos-container run <container-name> -- args...
       nixos-container show-ip <container-name>
       nixos-container show-host-key <container-name>
EOF
    exit 0;
}

my $systemPath;
my $nixosPath;
my $ensureUniqueName = 0;
my $autoStart = 0;
my $bridge;
my $port;
my $extraConfig;
my $signal;
my $configFile;
my $hostAddress;
my $localAddress;
my $flake;
my $flakeAttr = "container";

GetOptions(
    "help" => sub { showHelp() },
    "ensure-unique-name" => \$ensureUniqueName,
    "auto-start" => \$autoStart,
    "bridge=s" => \$bridge,
    "port=s" => \$port,
    "system-path=s" => \$systemPath,
    "signal=s" => \$signal,
    "nixos-path=s" => \$nixosPath,
    "config=s" => \$extraConfig,
    "config-file=s" => \$configFile,
    "host-address=s" => \$hostAddress,
    "local-address=s" => \$localAddress,
    "flake=s" => \$flake,
    ) or exit 1;

if (defined $hostAddress and !defined $localAddress or defined $localAddress and !defined $hostAddress) {
    die "With --host-address set, --local-address is required as well!";
}

my $action = $ARGV[0] or die "$0: no action specified\n";

if (defined $configFile and defined $extraConfig) {
    die "--config and --config-file are mutually incompatible. " .
        "Please define one or the other, but not both";
}

if (defined $flake && $flake =~ /^(.*)#([^#"]+)$/) {
    $flake = $1;
    $flakeAttr = $2;
}

# Execute the selected action.

mkpath("/etc/containers", 0, 0755);
mkpath("/var/lib/containers", 0, 0700);

if ($action eq "list") {
    foreach my $confFile (glob "/etc/containers/*.conf") {
        $confFile =~ /\/([^\/]+).conf$/ or next;
        print "$1\n";
    }
    exit 0;
}

my $containerName = $ARGV[1] or die "$0: no container name specified\n";
$containerName =~ /^[a-zA-Z0-9_-]+$/ or die "$0: invalid container name\n";

sub writeNixOSConfig {
    my ($nixosConfigFile) = @_;

    my $localExtraConfig = "";

    if ($extraConfig) {
        $localExtraConfig = $extraConfig
    } elsif ($configFile) {
        my $resolvedFile = abs_path($configFile);
        $localExtraConfig = "imports = [ $resolvedFile ];"
    }

    my $nixosConfig = <<EOF;
{ config, lib, pkgs, ... }:

with lib;

{ boot.isContainer = true;
  networking.hostName = mkDefault "$containerName";
  networking.useDHCP = false;
  $localExtraConfig
}
EOF

    write_file($nixosConfigFile, $nixosConfig);
}

sub buildFlake {
    system("nix", "build", "-o", "$systemPath.tmp", "--",
           "$flake#nixosConfigurations.\"$flakeAttr\".config.system.build.toplevel") == 0
        or die "$0: failed to build container from flake '$flake'\n";
    $systemPath = readlink("$systemPath.tmp") or die;
    unlink("$systemPath.tmp");
}

sub clearContainerState {
    my ($profileDir, $gcRootsDir, $root, $configFile) = @_;

    safeRemoveTree($profileDir) if -e $profileDir;
    safeRemoveTree($gcRootsDir) if -e $gcRootsDir;
    system("chattr", "-i", "$root/var/empty") if -e "$root/var/empty";
    safeRemoveTree($root) if -e $root;
    unlink($configFile) or die;
}

if ($action eq "create") {
    # Acquire an exclusive lock to prevent races with other
    # invocations of ‘nixos-container create’.
    my $lockFN = "/run/lock/nixos-container";
    open(my $lock, '>>', $lockFN) or die "$0: opening $lockFN: $!";
    flock($lock, LOCK_EX) or die "$0: could not lock $lockFN: $!";

    my $confFile = "/etc/containers/$containerName.conf";
    my $root = "/var/lib/containers/$containerName";

    # Maybe generate a unique name.
    if ($ensureUniqueName) {
        my $base = $containerName;
        for (my $nr = 0; ; $nr++) {
            $confFile = "/etc/containers/$containerName.conf";
            $root = "/var/lib/containers/$containerName";
            last unless -e $confFile || -e $root;
            $containerName = "$base-$nr";
        }
    }

    die "$0: container ‘$containerName’ already exists\n" if -e $confFile;

    # Due to interface name length restrictions, container names must
    # be restricted too.
    die "$0: container name ‘$containerName’ is too long\n" if length $containerName > 11;

    # Get an unused IP address.
    my %usedIPs;
    foreach my $confFile2 (glob "/etc/containers/*.conf") {
        my $s = read_file($confFile2) or die;
        $usedIPs{$1} = 1 if $s =~ /^HOST_ADDRESS=([0-9\.]+)$/m;
        $usedIPs{$1} = 1 if $s =~ /^LOCAL_ADDRESS=([0-9\.]+)$/m;
    }

    unless (defined $hostAddress) {
        my $ipPrefix;
        for (my $nr = 1; $nr < 255; $nr++) {
            $ipPrefix = "10.233.$nr";
            $hostAddress = "$ipPrefix.1";
            $localAddress = "$ipPrefix.2";
            last unless $usedIPs{$hostAddress} || $usedIPs{$localAddress};
            $ipPrefix = undef;
        }

        die "$0: out of IP addresses\n" unless defined $ipPrefix;
    }

    my @conf;
    push @conf, "PRIVATE_NETWORK=1\n";
    push @conf, "HOST_ADDRESS=$hostAddress\n";
    push @conf, "LOCAL_ADDRESS=$localAddress\n";
    push @conf, "HOST_BRIDGE=$bridge\n";
    push @conf, "HOST_PORT=$port\n";
    push @conf, "AUTO_START=$autoStart\n";
    push @conf, "FLAKE=$flake\n" if defined $flake;
    write_file($confFile, \@conf);

    close($lock);

    print STDERR "host IP is $hostAddress, container IP is $localAddress\n";

    # The per-container directory is restricted to prevent users on
    # the host from messing with guest users who happen to have the
    # same uid.
    my $profileDir = "/nix/var/nix/profiles/per-container";
    mkpath($profileDir, 0, 0700);
    $profileDir = "$profileDir/$containerName";
    mkpath($profileDir, 0, 0755);

    # Build/set the initial configuration.
    if (defined $flake) {
        buildFlake();
    }

    if (defined $systemPath) {
        system("nix-env", "-p", "$profileDir/system", "--set", $systemPath) == 0
            or do {
                clearContainerState($profileDir, "$profileDir/$containerName", $root, $confFile);
                die "$0: failed to set initial container configuration\n";
            };
    } else {
        mkpath("$root/etc/nixos", 0, 0755);

        my $nixenvF = $nixosPath // "<nixpkgs/nixos>";
        my $nixosConfigFile = "$root/etc/nixos/configuration.nix";
        writeNixOSConfig $nixosConfigFile;

        system("nix-env", "-p", "$profileDir/system",
               "-I", "nixos-config=$nixosConfigFile", "-f", "$nixenvF",
               "--set", "-A", "system") == 0
            or do {
                clearContainerState($profileDir, "$profileDir/$containerName", $root, $confFile);
                die "$0: failed to build initial container configuration\n"
            };
    }

    print "$containerName\n" if $ensureUniqueName;
    exit 0;
}

my $root = "/var/lib/containers/$containerName";
my $profileDir = "/nix/var/nix/profiles/per-container/$containerName";
my $gcRootsDir = "/nix/var/nix/gcroots/per-container/$containerName";
my $confFile = "/etc/containers/$containerName.conf";
if (!-e $confFile) {
    if ($action eq "destroy") {
        exit 0;
    } elsif ($action eq "status") {
        print "gone\n";
    }
    die "$0: container ‘$containerName’ does not exist\n" ;
}

# Return the PID of the init process of the container.
sub getLeader {
    my $s = `machinectl show "$containerName" -p Leader`;
    chomp $s;
    $s =~ /^Leader=(\d+)$/ or die "unable to get container's main PID\n";
    return int($1);
}

sub isContainerRunning {
    my $status = `systemctl show 'container\@$containerName'`;
    return $status =~ /ActiveState=active/;
}

sub terminateContainer {
    my $leader = getLeader;
    system("machinectl", "terminate", $containerName) == 0
        or die "$0: failed to terminate container\n";
    # Wait for the leader process to exit
    # TODO: As for any use of PIDs for process control where the process is
    #       not a direct child of ours, this can go wrong when the pid gets
    #       recycled after a PID overflow.
    #       Relying entirely on some form of UUID provided by machinectl
    #       instead of PIDs would remove this risk.
    #       See https://github.com/NixOS/nixpkgs/pull/32992#discussion_r158586048
    while ( kill 0, $leader ) { Time::HiRes::sleep(0.1) }
}

sub startContainer {
    system("systemctl", "start", "container\@$containerName") == 0
        or die "$0: failed to start container\n";
}

sub stopContainer {
    system("systemctl", "stop", "container\@$containerName") == 0
        or die "$0: failed to stop container\n";
}

sub restartContainer {
    stopContainer;
    startContainer;
}

# Run a command in the container.
sub runInContainer {
    my @args = @_;

    exec("systemd-run", "--machine", $containerName, "--pty", "--quiet", "--", @args);

    die "cannot run ‘systemd-run’: $!\n";
}

# Remove a directory while recursively unmounting all mounted filesystems within
# that directory and unmounting/removing that directory afterwards as well.
#
# NOTE: If the specified path is a mountpoint, its contents will be removed,
#       only mountpoints underneath that path will be unmounted properly.
sub safeRemoveTree {
    my ($path) = @_;
    system("find", $path, "-mindepth", "1", "-xdev",
           "(", "-type", "d", "-exec", "mountpoint", "-q", "{}", ";", ")",
           "-exec", "umount", "-fR", "{}", "+");
    system("rm", "--one-file-system", "-rf", $path);
    if (-e $path) {
        system("umount", "-fR", $path);
        system("rm", "--one-file-system", "-rf", $path);
    }
}

if ($action eq "destroy") {
    die "$0: cannot destroy declarative container (remove it from your configuration.nix instead)\n"
        unless POSIX::access($confFile, &POSIX::W_OK);

    terminateContainer if (isContainerRunning);

    clearContainerState($profileDir, $gcRootsDir, $root, $confFile);
}

elsif ($action eq "restart") {
    restartContainer;
}

elsif ($action eq "start") {
    startContainer;
}

elsif ($action eq "stop") {
    stopContainer;
}

elsif ($action eq "terminate") {
    terminateContainer;
}

elsif ($action eq "status") {
    print isContainerRunning() ? "up" : "down", "\n";
}

elsif ($action eq "update") {

    # Unless overriden on the command line, rebuild the flake recorded
    # in the container config file. FIXME: read the container config
    # in a more sensible way.
    if (!defined $flake && !defined $configFile && !defined $extraConfig) {
        my $s = read_file($confFile);
        $s =~ /^FLAKE=(.*)$/m;
        $flake = $1;
    }

    if (defined $flake) {
        buildFlake();
        system("nix-env", "-p", "$profileDir/system", "--set", $systemPath) == 0
            or die "$0: failed to set container configuration\n";
    } else {

        my $nixosConfigFile = "$root/etc/nixos/configuration.nix";

        # FIXME: may want to be more careful about clobbering the existing
        # configuration.nix.
        if ((defined $extraConfig && $extraConfig ne "") ||
            (defined $configFile && $configFile ne "")) {
            writeNixOSConfig $nixosConfigFile;
        }

        my $nixenvF = $nixosPath // "<nixpkgs/nixos>";
        system("nix-env", "-p", "$profileDir/system",
               "-I", "nixos-config=$nixosConfigFile", "-f", $nixenvF,
               "--set", "-A", "system") == 0
            or die "$0: failed to build container configuration\n";
    }

    if (isContainerRunning) {
        print STDERR "reloading container...\n";
        system("systemctl", "reload", "container\@$containerName") == 0
            or die "$0: failed to reload container\n";
    }
}

elsif ($action eq "login") {
    exec("machinectl", "login", "--", $containerName);
}

elsif ($action eq "root-login") {
    runInContainer("@su@", "root", "-l");
}

elsif ($action eq "run") {
    shift @ARGV; shift @ARGV;
    # Escape command.
    my $s = join(' ', map { s/'/'\\''/g; "'$_'" } @ARGV);
    runInContainer("@su@", "root", "-l", "-c", "exec " . $s);
}

elsif ($action eq "show-ip") {
    my $s = read_file($confFile) or die;
    $s =~ /^LOCAL_ADDRESS=([0-9\.]+)(\/[0-9]+)?$/m or die "$0: cannot get IP address\n";
    print "$1\n";
}

elsif ($action eq "show-host-key") {
    my $fn = "$root/etc/ssh/ssh_host_ed25519_key.pub";
    $fn = "$root/etc/ssh/ssh_host_ecdsa_key.pub" unless -e $fn;
    exit 1 if ! -f $fn;
    print read_file($fn);
}

else {
    die "$0: unknown action ‘$action’\n";
}
