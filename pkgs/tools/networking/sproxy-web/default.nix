{ cabal, aeson, blazeHtml, blazeMarkup, configurator, hflags
, httpTypes, mtl, postgresqlSimple, resourcePool, scotty, text
, waiExtra, waiMiddlewareStatic, fetchurl
}:

cabal.mkDerivation (self: {
  pname = "sproxy-web";
  version = "0.1.0.2";
  src = fetchurl {
    url = "https://github.com/zalora/sproxy-web/archive/0.1.0.2.tar.gz";
    sha256 = "1rdzglvsas0rdgq3j5c9ll411yk168x7v3l7w8zdjgafa947j4d4";
  };
  isLibrary = false;
  isExecutable = true;
  buildDepends = [
    aeson blazeHtml blazeMarkup configurator hflags httpTypes mtl
    postgresqlSimple resourcePool scotty text waiExtra
    waiMiddlewareStatic
  ];
  meta = {
    homepage = "http://bitbucket.org/zalorasea/sproxy-web";
    description = "Web interface to sproxy";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    broken = true;
  };
})
