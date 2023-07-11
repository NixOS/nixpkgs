{ poetry2nix, pkgs, lib }:

let
  pythonPackages = (poetry2nix.mkPoetryPackages {
    projectDir = ./.;
    overrides = [
      poetry2nix.defaultPoetryOverrides
      (import ./poetry-git-overlay.nix { inherit pkgs; })
      (self: super: {

        irrd = super.irrd.overridePythonAttrs (old: {
          prePatch = ''
            sed -i '/wheel/d' setup.py
          '';

          meta = old.meta // {
            description = "Internet Routing Registry daemon version 4 is an IRR database server, processing IRR objects in the RPSL format.";
            license = lib.licenses.mit;
            homepage = "https://github.com/irrdnet/irrd";
            maintainers = [ lib.maintainers.n0emis ];
          };
        });

        coredis = super.coredis.overridePythonAttrs (old: {
          buildInputs = old.buildInputs ++ [
            super.setuptools
          ];
        });

        ariadne = super.ariadne.overridePythonAttrs (old: {
          buildInputs = old.buildInputs ++ [
            super.setuptools
          ];
        });

      })
    ];
  }).python.pkgs;
in pythonPackages.irrd

