{stdenv, fetchurl, fetchFromGitHub, ucl, zlib, perl}:

stdenv.mkDerivation rec {
  name = "upx-${version}";
  version = "3.93";
  src = fetchFromGitHub {
    owner = "upx";
    repo = "upx";
    rev = "v${version}";
    sha256 = "03ah23q85hx3liqyyj4vm8vip2d47bijsimagqd39q762a2rin3i";
  };

  buildInputs = [ ucl zlib perl ];

  lzmaSrc = fetchFromGitHub {
    owner = "upx";
    repo = "upx-lzma-sdk";
    rev = "v${version}";
    sha256 = "16vj1c5bl04pzma0sr4saqk80y2iklyslzmrb4rm66aifa365zqj";
  };

  preConfigure = "
    export UPX_UCLDIR=${ucl}
    cp -a $lzmaSrc/* src/lzma-sdk
    export UPX_LZMADIR=`pwd`/src/lzma-sdk
    cd src
  ";

  buildPhase = "make CHECK_WHITESPACE=true";
  installPhase = "mkdir -p $out/bin ; cp upx.out $out/bin/upx";

  meta = {
    homepage = https://upx.github.io/;
    description = "The Ultimate Packer for eXecutables";
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.unix;
  };
}
