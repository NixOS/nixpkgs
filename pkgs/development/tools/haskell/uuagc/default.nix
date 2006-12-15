{stdenv, fetchurl, ghc, uulib}:

stdenv.mkDerivation
{
  name = "uuagc-0.9.2";

  src = fetchurl { url = http://www.cs.uu.nl/~ariem/uuagc-0.9.2-src.tar.gz;
                   md5 = "cbac92287c9c0a858ccbfa37615d9f5f";
                 };

  buildInputs = [ghc uulib];

  meta = { description = "The UUAG Compiler"; };
}
