{stdenv, fetchurl, ucl, zlib}:

stdenv.mkDerivation {
  name = "upx-3.91";
  src = fetchurl {
    url = mirror://sourceforge/upx/upx-3.91-src.tar.bz2;
    sha256 = "0g3aiinlcb37z1xhs202h2qrgbf8dygiyarmflbgahcq89byfz2j";
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
    license = stdenv.lib.licenses.gpl2Plus;
  };
}
