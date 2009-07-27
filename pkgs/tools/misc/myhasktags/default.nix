{fetchurl, stdenv, ghcReal} :

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
    sha256 = "9bd8ed2cfe814b40215574e3e6ac5c1741f47ad610675c85354f19ce611d2c4a";
  };
  phases="buildPhase";
  buildPhase = ''
    ensureDir $out/bin
    ghc --make $src -o $out/bin/hasktags-modified
  '';
  buildInputs = [ ghcReal ];

  meta = {
    description = "my patched version of hasktags. Should be merged into hasktags?";
  };
}
