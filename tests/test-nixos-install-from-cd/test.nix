{ nixos ? ../..
, nixpkgs ? ../../../nixpkgs
, services ? ../../../nixos/services
, system ? builtins.currentSystem
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

   If test fails at "waiting for socket" rerun the test

*/

  configuration_iso =  ./configuration-iso.nix;
  configuration_install = ./configuration.nix;

  release = (import ../../release.nix) { inherit nixpkgs; };

  isoFile = (
    release.makeIso 
      {
        module = configuration_iso;
        description = "minimal-testing-only";
        maintainers = ["MarcWeber"];
      }
      { inherit system; }
      ).iso;

  eval = import ../../lib/eval-config.nix {
    inherit system nixpkgs;
    modules = [ configuration_install ];
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

    # TODO add nix-env -i command and verify that root can install additional
    # tools such as git or sshfs-fuse!
    pkgs.runCommand "nixos-installation-test" { inherit systemDerivation; } ''

    INFO(){ echo "INFO: " $@; }

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

    # don't ask me why I have to remove the socket.. If I don't it won't be
    # reused by kvm_qemu!
    rm $SOCKET_NAME || true
    exec qemu-system-x86_64 -m 512 \
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
    # 2GB = data; 1GB=swap
    # Maybe using 1GB swap is much. But qcow2 doesn't fill holes so it only
    # used when required (?)
    qemu-img create -f qcow2 image 3G

    RUN_KVM -boot d -cdrom $(echo ${isoFile}/iso/*.iso)
    
    waitForSSHD

    # INSTALLATION
    INFO "creating filesystem .."
    SSH_STDIN_E << EOF
      set -x
      parted /dev/sda mklabel msdos
      parted /dev/sda mkpart primary 0 2G
      parted /dev/sda mkpart primary 1G 3G
      waitFor(){
        while [ ! -e "\$1" ]; do
          echo "waiting for \$1 to appear"; sleep 1;
        done
      }
      waitFor /dev/sda2
      mkswap /dev/sda2
      swapon /dev/sda2

      waitFor /dev/sda1
      mkfs.ext3 /dev/sda1

      mount /dev/sda1 /mnt
      mkdir -p /mnt/nix-on-host
      mount //10.0.2.4/qemu -oguest,username=nobody,noperm -tcifs /mnt/nix-on-host
    EOF


    SSH_STDIN_E << EOF
      # simple nixos-hardware-scan syntax check:
      nixos-hardware-scan > /tmp/test.nix
    EOF

    INFO "copying sources and Nix, starting installation"
    SSH_STDIN_E << EOF

      nixos-prepare-install

      # has the generated configuration.nix file syntax errors?
      nix-instantiate --eval-only /tmp/test.nix

      echo 'export NIXOS_CONFIG=/etc/nixos/nixos/tests/test-nixos-install-from-cd/configuration.nix' >> /root/.bashrc
      . ~/.bashrc
      export NIX_OTHER_STORES=/nix-on-host

      run-in-chroot "/nix/store/nixos-bootstrap --install --no-pull"
      #nixos-install
    EOF

    SHUTDOWN_VM

    INFO "booting installed system"
    RUN_KVM -boot c
    waitForSSHD


    INFO "verifying that nix-env -i works"

    SSH_STDIN_E << EOF

      cat >> test.nix << EOF_TEST
      let pkgs = import /etc/nixos/nixpkgs/pkgs/top-level/all-packages.nix {};
      in pkgs.stdenv.mkDerivation {
        name = "test";
        phases = "create_out";
        create_out = "mkdir -p $out/ok";
      }
    EOF_TEST

      set -x
      nix-env -i -f test.nix
      [ -e ~/.nix-profile/ok ]
    EOF

    SHUTDOWN_VM

    echo "$(date) success" > $out
  '';
}
