{ stdenv, fetchurl, ucl, zlib, perl }:

stdenv.mkDerivation rec {
  name = "upx-${version}";
  version = "3.95";
  src = fetchurl {
    url = "https://github.com/upx/upx/releases/download/v${version}/${name}-src.tar.xz";
    sha256 = "14jmgy7hvx4zqra20w8260wrcxmjf2h6ba2yrw7pcp18im35a3rv";
  };

  CXXFLAGS = "-Wno-unused-command-line-argument";

  buildInputs = [ ucl zlib perl ];

  preConfigure = ''
    export UPX_UCLDIR=${ucl}
  '';

  makeFlags = [ "-C" "src" "CHECK_WHITESPACE=true" ];

  installPhase = ''
    mkdir -p $out/bin
    cp src/upx.out $out/bin/upx
  '';

  meta = with stdenv.lib; {
    homepage = https://upx.github.io/;
    description = "The Ultimate Packer for eXecutables";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
  };
}
