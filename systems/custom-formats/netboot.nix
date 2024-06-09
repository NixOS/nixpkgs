{modulesPath, pkgs, config, ... }: {

  imports = [
    "${toString modulesPath}/installer/netboot/netboot-minimal.nix"
  ];

  system.build = rec {
    image = pkgs.runCommand "image" { buildInputs = [ pkgs.nukeReferences ]; } ''
      mkdir $out
      cp ${config.system.build.kernel}/${config.system.boot.loader.kernelFile} $out/kernel
      cp ${config.system.build.netbootRamdisk}/initrd $out/initrd
      cp ${config.system.build.ipxe_script} $out/ipxe
      echo "init=${builtins.unsafeDiscardStringContext config.system.build.toplevel}/init ${toString config.boot.kernelParams}" > $out/cmdline

      nuke-refs $out/kernel
    '';
    xnode_version = "0";
    xnode_uuid = "303a03f7-0619-4bd2-85b7-a56c7e12c4b6"; # XU Controller inserts these already
    xnode_access_token = "TEEH0Km2gOEppGnArOeqir776lr3F7GisdjRMeQ0YoX4rcmuilV3e5vaPFCM8JFn";
    ipxe_script = pkgs.writeTextFile {
      executable = false;
      name = "ipxe";

      text = ''
        #!ipxe
        # TODO: MAKE CONFIGURABLE WITH iPXE VARS for CHAINLOAD
        kernel http://127.0.0.1:8000/kernel initrd=initrd init=${builtins.unsafeDiscardStringContext config.system.build.toplevel}/init ${toString config.boot.kernelParams} XNODE_VERSION=${xnode_version} XNODE_UUID=${xnode_uuid} XNODE_ACCESS_TOKEN=${xnode_access_token}
        initrd http://127.0.0.1:8000/initrd
        boot
      '';
    };

  };

  formatAttr = "image";
}
