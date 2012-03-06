{stdenv, fetchurl, ucl, zlib}:

stdenv.mkDerivation {
  name = "upx-3.07";
  src = fetchurl {
    url = http://upx.sourceforge.net/download/upx-3.07-src.tar.bz2;
    sha256 = "07pcgjn7x0a734mvhgqwz24qkm1rzqrkcp67pmagzz6i765cp7bs";
  };

  buildInputs = [ ucl zlib ];

  lzmaSrc = fetchurl {
    url = mirror://sourceforge/sevenzip/lzma443.tar.bz2;
    sha256 = "1ck4z81y6xv1x9ky8abqn3mj9xj2dwg41bmd5j431xgi8crgd1ds";
  };

  preConfigure = "
    export UPX_UCLDIR=${ucl}
    mkdir lzma443
    pushd lzma443
    tar xf $lzmaSrc
    popd
    export UPX_LZMADIR=`pwd`/lzma443
    cd src
  ";

  installPhase = "mkdir -p $out/bin ; cp upx.out $out/bin/upx";

  meta = {
    homepage = http://upx.sourceforge.net/;
    description = "The Ultimate Packer for eXecutables";
    license = "GPLv2+";
  };
}
