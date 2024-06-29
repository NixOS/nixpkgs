{ lib
, stdenv
, callPackage
, symlinkJoin
, makeBinaryWrapper
, desktopToDarwinBundle
, ghidra
}:

let
  ghidra-extensions = callPackage ./extensions.nix { inherit ghidra; };
  allExtensions = lib.filterAttrs (n: pkg: lib.isDerivation pkg) ghidra-extensions;

  /* Make Ghidra with additional extensions
     Example:
       pkgs.ghidra.withExtensions (p: with p; [
         ghostrings
       ]);
       => /nix/store/3yn0rbnz5mbrxf0x70jbjq73wgkszr5c-ghidra-with-extensions-10.2.2
  */
  withExtensions = f: (symlinkJoin {
    name = "${ghidra.pname}-with-extensions-${lib.getVersion ghidra}";
    paths = (f allExtensions);
    nativeBuildInputs = [ makeBinaryWrapper ]
      ++ lib.optional stdenv.hostPlatform.isDarwin desktopToDarwinBundle;
    postBuild = ''
      makeWrapper '${ghidra}/bin/ghidra' "$out/bin/ghidra" \
        --set NIX_GHIDRAHOME "$out/lib/ghidra/Ghidra"
      ln -s ${ghidra}/share $out/share
    '' + lib.optionalString stdenv.hostPlatform.isDarwin ''
      convertDesktopFiles $prefix
    '';
    inherit (ghidra) meta;
  });
in
  withExtensions
