{stdenv, fetchurl, fetchFromGitHub, ucl, zlib, perl}:

stdenv.mkDerivation rec {
  name = "upx-${version}";
  version = "3.94";
  src = fetchurl {
    url = "https://github.com/upx/upx/releases/download/v3.94/upx-3.94-src.tar.xz";
    sha256 = "08anybdliqsbsl6x835iwzljahnm9i7v26icdjkcv33xmk6p5vw1";
  };

  buildInputs = [ ucl zlib perl ];

  preConfigure = "
    export UPX_UCLDIR=${ucl}
    cd src
  ";

  makeFlags = [ "CHECK_WHITESPACE=true" ];

  installPhase = "mkdir -p $out/bin ; cp upx.out $out/bin/upx";

  meta = {
    homepage = https://upx.github.io/;
    description = "The Ultimate Packer for eXecutables";
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.unix;
  };
}
