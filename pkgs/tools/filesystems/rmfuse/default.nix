{ poetry2nix, pkgs, lib }:

let
  pythonPackages = (poetry2nix.mkPoetryPackages {
    projectDir = ./.;
    overrides = [
      poetry2nix.defaultPoetryOverrides
      (import ./poetry-git-overlay.nix { inherit pkgs; })
      (self: super: {

        rmfuse = super.rmfuse.overridePythonAttrs(old: {
          meta = old.meta // {
            description = "RMfuse provides access to your reMarkable Cloud files in the form of a FUSE filesystem.";
            longDescription = ''
              RMfuse provides access to your reMarkable Cloud files in the form of a FUSE filesystem. These files are exposed either in their original format, or as PDF files that contain your annotations. This lets you manage files in the reMarkable Cloud using the same tools you use on your local system.
            '';
            license = lib.licenses.mit;
            homepage = "https://github.com/rschroll/rmfuse";
            maintainers = [ lib.maintainers.adisbladis ];
          };
        });

        reportlab = let
          ft = pkgs.freetype.overrideAttrs (oldArgs: { dontDisableStatic = true; });
        in super.reportlab.overridePythonAttrs(old: {
          postPatch = ''
            substituteInPlace setup.py \
              --replace "mif = findFile(d,'ft2build.h')" "mif = findFile('${lib.getDev ft}','ft2build.h')"
          '';

          NIX_CFLAGS_COMPILE = "-I${pkgs.freetype}/include/freetype2";

          nativeBuildInputs = old.nativeBuildInputs ++ [
            pkgs.pkg-config
          ];
          buildInputs = old.buildInputs ++ [
            pkgs.freetype
          ];
        });

      })
    ];
  }).python.pkgs;
in pythonPackages.rmfuse
