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
    sha256 = "e5ce4c4e1f5916baf9395174978faee67a86ff5350936c82e115939812a4d579";
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
