{ pkgs, ... }:

{
  machine =
    { config, pkgs, ... }:

    {
      nixpkgs.config.packageOverrides = origPkgs: {
        cpio = pkgs.lib.overrideDerivation origPkgs.cpio (origAttrs: {
          src = /home/eelco/Dev/nixpkgs/cpio-2.10.91.tar.bz2;
          patches = [];
        });
      };
    };

  testScript =
    ''
      $machine->mustSucceed("cpio --help");
    '';
}
