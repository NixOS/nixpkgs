{ttf2pt1, lib, fetchurl, unzip}:

lib.overrideDerivation ttf2pt1 
(x:
{
  name = "ttf2pt1-cl-pdf";
  src = fetchurl {
    url = "http://www.fractalconcept.com/fcweb/download/ttf2pt1-src.zip";
    sha256 = "1w6kxgnrj3x67lf346bswmcqny9lmyhbnkp6kv99l6wfaq4gs82b";
  };
  buildInputs = x.buildInputs ++ [unzip];
  sourceRoot = "ttf2pt1-cl-pdf";
  preBuild = ''
    chmod a+x scripts/*
  '';
  meta = x.meta // {
    maintainers = [lib.maintainers.raskin];
    platforms = lib.platforms.linux;
  };
})
