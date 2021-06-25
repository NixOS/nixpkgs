{
  buildEnv,
  lib,
  man,
  nixos,
  # TODO: replace indirect self-reference by proper self-reference
  #       https://github.com/NixOS/nixpkgs/pull/119942
  nixos-install-tools,
  runCommand,
}:
let
  inherit (nixos {}) config;
  version = config.system.nixos.version;
in
(buildEnv {
  name = "nixos-install-tools-${version}";
  paths = lib.attrValues {
    # See nixos/modules/installer/tools/tools.nix
    inherit (config.system.build)
      nixos-install nixos-generate-config nixos-enter;

    # Required for --help.
    inherit (config.system.build.manual) manpages;
  };

  extraOutputsToInstall = ["man"];

  meta = {
    description = "The essential commands from the NixOS installer as a package";
    longDescription = ''
      With this package, you get the commands like nixos-generate-config and
      nixos-install that you would otherwise only find on a NixOS system, such
      as an installer image.

      This way, you can install NixOS using a machine that only has Nix.
    '';
    license = lib.licenses.mit;
    homepage = "https://nixos.org";
    platforms = lib.platforms.linux;
  };

  passthru.tests = {
    nixos-install-help = runCommand "test-nixos-install-help" {
      nativeBuildInputs = [
        man
        nixos-install-tools
      ];
      meta.description = ''
        Make sure that --help works. It's somewhat non-trivial because it
        requires man.
      '';
    } ''
      nixos-install --help | grep -F 'NixOS Reference Pages'
      nixos-install --help | grep -F 'configuration.nix'
      nixos-generate-config --help | grep -F 'NixOS Reference Pages'
      nixos-generate-config --help | grep -F 'hardware-configuration.nix'

      # FIXME: Tries to call unshare, which it must not do for --help
      # nixos-enter --help | grep -F 'NixOS Reference Pages'

      touch $out
    '';
  };
}).overrideAttrs (o: {
  inherit version;
  pname = "nixos-install-tools";
})
