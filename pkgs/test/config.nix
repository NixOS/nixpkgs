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
        # Allow with forgetting
        tempAllow = p: v: pa:
          lib.optionals (lib.assertMsg (p.version == v) "${p.name} is no longer at version ${v}, consider removing the tempAllow") pa;
        # For this test we don't _really_ care about the version though,
        # only about evaluation strictness
        tempAllowAlike = p: v: pa: builtins.seq v builtins.seq p.version pa;

    in pkgs.hello;

}
