# A test script is created testing the installer2 scripts
# This can't be a build job because chroot is required - sudo is used
# 
# # build test script:
# nix-build tests/test-nixos-installer2.nix -A test
# 
# # run:
# sudo result/bin/test

{ nixos ? ./..
, nixpkgs ? ../../nixpkgs
, services ? ../../nixos/services
, system ? builtins.currentSystem
, configPath ? ./test-nixos-install-from-cd.nix
}:

let

  isos = (import ../release.nix) { inherit nixpkgs; };

  # using same configuration as ased by kvm test.
  configuration = ../modules/installer/cd-dvd/test-nixos-install-from-cd-config.nix;

  eval = import ../lib/eval-config.nix {
    inherit system nixpkgs;
    modules = [ configuration ];
  };


  inherit (eval) pkgs config;

  inherit (pkgs) qemu_kvm;

  # prebuild system which will be installed for two reasons:
  # build derivations are in store and can be reused
  # the iso is only build when this suceeds (?)
  systemDerivation = builtins.addErrorContext "while building system" config.system.build.toplevel;


  tools = config.system.build;

in

rec {

  test = pkgs.writeScriptBin "test"  ''
    #!/bin/sh -e
    # DEBUG can be set to --debug to force set -x in scripts

    export mountPoint=''${mountPoint:-`pwd`/mountPoint}
    if [ -e "$mountPoint" ]; then
      echo "mountPoint $mountPoint exists, delete? [y] | other key: continue"
      read -n1 delete
      if [ "$delete" == "y" ]; then
        rm -fr $mountPoint
      fi
    fi
    mkdir -p $mountPoint

    set -x

    ${tools.nixosPrepareInstall}/bin/nixos-prepare-install $DEBUG --dir-ok copy-nixos-bootstrap copy-nix copy-sources

    cp ${configuration} $mountPoint/etc/nixos/configuration.nix

    # at least one of those files is referenced. So copy all - they don't hurt
    cp -r ${builtins.dirOf (builtins.toString configuration)}/* $mountPoint/etc/nixos

    ${tools.runInChroot}/bin/run-in-chroot $DEBUG "/nix/store/nixos-bootstrap $DEBUG --install --no-grub"
  '';
}
