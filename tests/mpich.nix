# Simple example to showcase distributed tests using NixOS VMs.

{ pkgs, ... }:

with pkgs;

{
  nodes = {
    master =
      { config, pkgs, ... }: {
        environment.systemPackages = [ gcc mpich2 ];
        #boot.kernelPackages = pkgs.kernelPackages_2_6_29;
      };

    slave =
      { config, pkgs, ... }: {
        environment.systemPackages = [ gcc mpich2 ];
      };
  };

  # Start master/slave MPI daemons and compile/run a program that uses both
  # nodes.
  testScript =
    ''
       startAll;

       $master->mustSucceed("echo 'MPD_SECRETWORD=secret' > /etc/mpd.conf");
       $master->mustSucceed("chmod 600 /etc/mpd.conf");
       $master->mustSucceed("mpd --daemon --ifhn=master --listenport=4444");

       $slave->mustSucceed("echo 'MPD_SECRETWORD=secret' > /etc/mpd.conf");
       $slave->mustSucceed("chmod 600 /etc/mpd.conf");
       $slave->mustSucceed("mpd --daemon --host=master --port=4444");

       $master->mustSucceed("mpicc -o example -Wall ${./mpich-example.c}");
       $slave->mustSucceed("mpicc -o example -Wall ${./mpich-example.c}");

       $master->mustSucceed("mpiexec -n 2 ./example >&2");
    '';
}
