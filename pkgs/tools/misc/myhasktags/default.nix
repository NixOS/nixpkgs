{fetchurl, stdenv, ghcPlain} :

/* use case:

   packageOverrides = {

    haskellCollection =
     let hp = haskellPackages;
         install = [ hp.QuickCheck /* ... * /];
      in
      misc.collection {
        name = "my-haskell-packages-collection";
        list = install ++ (map (x : sourceWithTagsDerivation (sourceWithTagsFromDerivation (addHasktagsTaggingInfo x) ))
                            (lib.filter (x : builtins.hasAttr "src" x) install ) );
      };
   };

*/

stdenv.mkDerivation {
  name = "hasktags-modified";
  version = "0.0"; # Haskell Platform 2009.0.0
  src = fetchurl {
    url = http://mawercer.de/~nix/hasktags.hs;
    sha256 = "0zdin03n357viyyqbn2d029jxd83nyazhaxbxfc8v3jrz5pkwl2c";
  };
  phases="buildPhase";
  buildPhase = ''
    mkdir -p $out/bin
    ghc --make $src -o $out/bin/hasktags-modified
  '';
  buildInputs = [ ghcPlain ];

  meta = {
    description = "my patched version of hasktags. Should be merged into hasktags?";
  };
}
