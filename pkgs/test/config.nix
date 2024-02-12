{ lib, ... }:
lib.recurseIntoAttrs {

  # https://github.com/NixOS/nixpkgs/issues/175196
  allowPkgsInPermittedInsecurePackages =
    let pkgs = import ../.. {
          config = {
            permittedInsecurePackages =
              tempAllow pkgs.authy "2.1.0" [ "electron-9.4.4" ];
          };
        };
        # A simplification of `tempAllow` that doesn't check the version, but
        # has the same strictness characteristics. Actually checking a version
        # here would add undue maintenance.
        #
        # Original:
        #     tempAllow = p: v: pa:
        #       lib.optionals (lib.assertMsg (p.version == v) "${p.name} is no longer at version ${v}, consider removing the tempAllow") pa;
        #
        tempAllow = p: v: pa: builtins.seq v builtins.seq p.version pa;

    in pkgs.hello;

}
