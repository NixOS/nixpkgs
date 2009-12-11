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

  configuration = /pr/system_nixos_installer/nixos/tests/test-nixos-install-from-cd-config.nix;

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

in

rec {

  test = 
    # FIXME: support i686 as well 
    # FIXME: X shouldn't be required
    # Is there a way to use kvm when not running as root?
    # Would using uml provide any advantages?
    pkgs.runCommand "nixos-installation-test" { inherit systemDerivation; } ''

    for path in ${pkgs.socat} ${pkgs.openssh} ${qemu_kvm}; do
      PATH=$path/bin:$PATH
    done

    echo "creating image file"
    qemu-img create -f qcow2 image 512M

    # install the system

    export DISPLAY=localhost:0.0

    cat >> run-kvm.sh << EOF
    #!/bin/sh
    qemu-system-x86_64 -m 620 \
        -no-kvm-irqchip \
        -net nic -net user -smb \
        -hda image \
        -cdrom $(echo ${isoFile}/iso/*.iso) \
        "\$@"
    EOF
    chmod +x run-kvm.sh

    SOCKET_NAME=65535.socket

    # run qemu-kvm in a background process
    { ./run-kvm.sh -boot d -redir tcp:''${SOCKET_NAME/.socket/}::22 \
      || { echo "starting kvm failed, exiting" 1>&2; pkill -9 $$; }
    } &
    
    # check that vm is still running
    checkVM(){ [ -n "$(jobs -l)" ] || { echo "kvm died!?"; exit 1; }; }

    waitTill(){
      echo $1
      while ! eval "$2"; do sleep 1; checkVM; done
    }

    SSH(){
      ssh -v -o UserKnownHostsFile=/dev/null \
        -o StrictHostKeyChecking=no \
        -o ProxyCommand="socat stdio ./$SOCKET_NAME" \
        root@127.0.0.1 \
        "$@";
    }

    # wait for socket

    waitTill "waiting for socket in $TMP" '[ ! -e ./$SOCKET_NAME ]'
    waitTill "waiting for sshd job" "SSH 'echo Hello > /dev/tty1'"

    # INSTALLATION
    echo "installation should take place"  

    # REBOOT 
    echo "rebooting should take place"  

    # CHECK
    echo "verify system is up and running"  

    # SHUTDOWN
    SSH "shutdown -h now"

    echo waiting for kvm to shutdown..
    wait
  '';
}
