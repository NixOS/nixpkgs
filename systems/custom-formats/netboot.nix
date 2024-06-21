{modulesPath, pkgs, config, ... }: {

  imports = [
    "${toString modulesPath}/installer/netboot/netboot-minimal.nix"
  ];

  system.build = rec {
    image = pkgs.runCommand "image" { buildInputs = [ pkgs.nukeReferences ]; } ''
      mkdir $out
      cp ${config.system.build.kernel}/${config.system.boot.loader.kernelFile} $out/kernel
      cp ${config.system.build.netbootRamdisk}/initrd $out/initrd
      cp ${config.system.build.ipxe_test_entrypoint_script} $out/ipxe_test_entrypoint
      cp ${config.system.build.ipxe_script} $out/ipxe
      echo "init=${builtins.unsafeDiscardStringContext config.system.build.toplevel}/init ${toString config.boot.kernelParams}" > $out/cmdline

      nuke-refs $out/kernel
    '';
    xnode_version = "0";
    xnode_uuid = "I5KMFECV11H-VX5K78G4P7I";
    xnode_access_token = "Tah6WlMnal0mpka6ki8jHmoD9hhK9KXc81xyNjvSt1hm1nj74dlM4W8jPEdPdmSJD1JVba+eDHEceUysRZnplw==";

    ipxe_test_entrypoint_script = pkgs.writeTextFile {
      executable = false;
      name = "ipxe_test_entrypoint";

      text = ''
        #!ipxe
        set xnode_version 0
        set xnode_uuid ${xnode_uuid}
        set xnode_access_token ${xnode_access_token}
        chain http://127.0.0.1:8000/ipxe
      '';
    };

    ipxe_script = pkgs.writeTextFile {
      executable = false;
      name = "ipxe";
      text = ''
        #!ipxe
        # Admin Service Expects the following to be set for initialisation in the chainloading iPXE script:
        #   - xnode_version
        #   - xnode_uuid
        #   - xnode_access_token
        kernel http://127.0.0.1:8000/kernel initrd=initrd init=${builtins.unsafeDiscardStringContext config.system.build.toplevel}/init ${toString config.boot.kernelParams} -- XNODE_VERSION=''${xnode_version} XNODE_UUID=''${xnode_uuid} XNODE_ACCESS_TOKEN=''${xnode_access_token}
        initrd http://127.0.0.1:8000/initrd
        boot
      '';
    };

  };

  formatAttr = "image";
}
