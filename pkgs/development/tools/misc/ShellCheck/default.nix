{ cabal, json, mtl, parsec, regexCompat }:

cabal.mkDerivation (self: {
  pname = "ShellCheck";
  version = "0.3.3";
  sha256 = "15lmc7cbi6s852qhd6h9asgz7ss1khfhq7wj4sgblr5mgppldg93";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ json mtl parsec regexCompat ];
  meta = {
    homepage = "http://www.shellcheck.net/";
    description = "Shell script analysis tool";
    license = self.stdenv.lib.licenses.agpl3Plus;
    platforms = self.ghc.meta.platforms;
  };
})
