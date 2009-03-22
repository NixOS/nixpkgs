{stdenv, fetchurl, ucl, zlib}:

stdenv.mkDerivation {
  name = "upx-3.03";
  src = fetchurl {
    url = http://upx.sourceforge.net/download/upx-3.03-src.tar.bz2;
    sha256 = "a04b0decd01d3ca194b9553c7bbf8a01bc17e0e06eb0850f4271bba783143d7b";
  };
  buildInputs = [ ucl zlib ];

  preConfigure = "cd src";

  installPhase = "ensureDir $out/bin ; cp upx.out $out/bin/upx";

  meta = {
    homepage = http://upx.sourceforge.net/;
    description = "The Ultimate Packer for eXecutables";
    license = "GPLv2+";
  };
}
