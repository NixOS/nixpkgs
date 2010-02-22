{stdenv, fetchurl, ucl, zlib}:

stdenv.mkDerivation {
  name = "upx-3.04";
  src = fetchurl {
    url = http://upx.sourceforge.net/download/upx-3.04-src.tar.bz2;
    sha256 = "15vxjzaf21vfanidv6d0zf37jgy4xfhn399nc66651b064pnbf39";
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
