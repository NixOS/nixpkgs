{ nixos ? ./..
, nixpkgs ? ../../nixpkgs
, services ? ../../nixos/services
, system ? builtins.currentSystem
, configPath ? ./test-nixos-install-from-cd.nix
}:

let

/*

   test nixos installation automatically using a build job (unfinished)

   run this test this way:
   nix-build --no-out-link --show-trace tests/test-nixos-install-from-cd.nix

   --no-out-link is important because creating ./result will cause rebuilding of
   the iso as the nixos repository is included in the iso.

   To prevent this make these paths point to another location:
   nixosTarball = makeTarball "nixos.tar.bz2" (cleanSource ../../..);
   nixpkgsTarball = makeTarball "nixpkgs.tar.bz2" (cleanSource pkgs.path);

*/

  isos = (import ../release.nix) { inherit nixpkgs; };

  isoFile = 
    # passed system = systom of iso 
    (isos.iso_minimal_test_insecure { inherit system; }).iso;

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

  # TODO test both: copyKernels = true and false. true doesn't work ?

in

rec {

  test = 
    # FIXME: support i686 as well 
    # FIXME: X shouldn't be required
    # Is there a way to use kvm when not running as root?
    # Would using uml provide any advantages?
    pkgs.runCommand "nixos-installation-test" { inherit systemDerivation; } ''

    INFO(){ echo $@; }

    die(){ echo $@; exit 1; }

    if ${pkgs.procps}/bin/ps aux | grep -v grep | grep sbin/nmbd ; then
      die "!! aborting: -smb won't work when host is running samba!"
    fi 

    [ -e /dev/kvm ] || die "modprobe a kvm-* module /dev/kvm not present. You want it for speed reasons!"

    for path in ${pkgs.socat} ${pkgs.openssh} ${qemu_kvm}; do
      PATH=$path/bin:$PATH
    done

    # without samba -smb doesn't work
    PATH=${pkgs.samba}/sbin:$PATH

    # install the system

    export DISPLAY=localhost:0.0

    SOCKET_NAME=65535.socket

    # creating shell script for debugging purposes
    cat >> run-kvm.sh << EOF
    #!/bin/sh -e
    # maybe swap should be used ?
    exec qemu-system-x86_64 -m 2048 \
        -no-kvm-irqchip \
        -net nic,model=virtio -net user -smb /nix \
        -hda image \
        -redir tcp:''${SOCKET_NAME/.socket/}::22 \
        "\$@"
    EOF
    chmod +x run-kvm.sh

    RUN_KVM(){
      INFO "launching qemu-kvm in a background process"
      { ./run-kvm.sh "$@" \
        || { echo "starting kvm failed, exiting" 1>&2; kill -9 $$; }
      } &
    }

    waitTill(){
      echo $1
      while ! eval "$2"; do sleep 1; done
    }

    SSH(){
      ssh -o UserKnownHostsFile=/dev/null \
        -o StrictHostKeyChecking=no \
        -o ProxyCommand="socat stdio ./$SOCKET_NAME" \
        root@127.0.0.1 \
        "$@";
    }
    SSH_STDIN_E(){ { echo "set -e;"; cat; } | SSH; }

    SHUTDOWN_VM(){
      SSH 'shutdown -h now';
      INFO "waiting for kvm to shutown"
      wait
    }

    # wait for socket

    waitForSSHD(){
      waitTill "waiting for socket in $TMP" '[ ! -e ./$SOCKET_NAME ]'
      waitTill "waiting for sshd job" "SSH 'echo Hello > /dev/tty1' &> /dev/null"
    }



    ### test installting NixOS: install system then reboot


    INFO "creating image file"
    qemu-img create -f qcow2 image 2G

    RUN_KVM -boot d -cdrom $(echo ${isoFile}/iso/*.iso)
    
    waitForSSHD

    # INSTALLATION
    INFO "creating filesystem .."
    SSH_STDIN_E << EOF
      parted /dev/sda mklabel msdos
      parted /dev/sda mkpart primary 0 2G
      while [ ! -e /dev/sda1 ]; do
        echo "waiting for /dev/sda1 to appear"
        sleep 1;
      done
      mkfs.ext3 /dev/sda1
      mount /dev/sda1 /mnt
      mkdir -p /mnt/nix-on-host
      mount //10.0.2.4/qemu -oguest,username=nobody,noperm -tcifs /mnt/nix-on-host
    EOF


    SSH_STDIN_E << EOF
      # simple nixos-hardware-scan syntax check:
      nixos-hardware-scan > /tmp/test.nix
    EOF

    INFO "copying sources and Nix, preparing configuration, starting installation"
    SSH_STDIN_E << EOF

      nixos-prepare-install

      # has the generated configuration.nix file syntax errors?
      nix-instantiate --eval-only /tmp/test.nix

      # NixOS sources are in /etc/nixos, copy those configuration files.
      cp /etc/nixos/nixos/modules/installer/cd-dvd/test-nixos-install-from-cd-config.nix /mnt/etc/nixos/configuration.nix
      # the configuration file is referencing additional files:
      cp -r /etc/nixos/nixos/modules/installer/cd-dvd/*.nix /mnt/etc/nixos/
      export NIX_OTHER_STORES=/nix-on-host
      run-in-chroot "/nix/store/nixos-bootstrap --install"
      #nixos-install
    EOF

    SHUTDOWN_VM

    INFO "booting installed system"
    RUN_KVM -boot c
    waitForSSHD
    SHUTDOWN_VM

    echo "$(date) success" > $out
  '';
}
