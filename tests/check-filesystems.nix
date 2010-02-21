{ nixos ? ./..
, nixpkgs ? /etc/nixos/nixpkgs
, services ? /etc/nixos/services
, system ? builtins.currentSystem
}:

with import ../lib/build-vms.nix { inherit nixos nixpkgs services system; };

rec {
  nodes = {
    share = {pkgs, config, ...}: {
      services.portmap.enable = true;
      services.nfsKernel.client.enable = true;
      services.nfsKernel.server.enable = true;
      services.nfsKernel.server.exports = ''
        /repos1 192.168.1.0/255.255.255.0(rw,no_root_squash)
        /repos2 192.168.1.0/255.255.255.0(rw,no_root_squash)
      '';
      services.nfsKernel.server.createMountPoints = true;

      jobs.checkable = {
        startOn = [
          config.jobs.nfs_kernel_exports.name
          config.jobs.nfs_kernel_nfsd.name
        ];
        respawn = true;
      };
    };

    fsCheck = {pkgs, config, ...}: {
      # enable nfs import
      services.portmap.enable = true;
      services.nfsKernel.client.enable = true;

      fileSystems =
        let
          repos1 = {
            mountPoint = "/repos1";
            autocreate = true;
            device = "share:/repos1";
          };

          repos2 = {
            mountPoint = "/repos2";
            autocreate = true;
            device = "share:/repos2";
          };
        in pkgs.lib.mkOverride 50 {} [ 
          repos1
          repos1 # check remount 
          repos2 # check after remount
        ];

      jobs.checkable = {
        startOn = "stopped ${config.jobs.filesystems.name}";
        respawn = true;
      };
    };
  };
    
  vms = buildVirtualNetwork { inherit nodes; };

  test = runTests vms
    ''
      startAll;

      $share->waitForJob("checkable");
      $fsCheck->waitForJob("checkable");

      # check repos1
      $fsCheck->mustSucceed("test -d /repos1");
      $share->mustSucceed("touch /repos1/test1");
      $fsCheck->mustSucceed("test -e /repos1/test1");

      # check repos2 (check after remount)
      $fsCheck->mustSucceed("test -d /repos2");
      $share->mustSucceed("touch /repos2/test2");
      $fsCheck->mustSucceed("test -e /repos2/test2");

      # check without network
      $share->block();
      $fsCheck->mustFail("test -e /repos1/test1");
      $fsCheck->mustFail("test -e /repos2/test2");
    '';
}
