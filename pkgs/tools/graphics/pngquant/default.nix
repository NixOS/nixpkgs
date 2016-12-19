{ stdenv, fetchFromGitHub, pkgconfig, libpng, zlib, lcms2 }:

stdenv.mkDerivation rec {
  name = "pngquant-${version}";
  version = "2.6.0";

  src = fetchFromGitHub {
    owner = "pornel";
    repo = "pngquant";
    rev = version;
    sha256 = "0sdh9cz330rhj6xvqk3sdhy0393qwyl349klk9r55g88rjp774s5";
  };

  preConfigure = "patchShebangs .";

  buildInputs = [ pkgconfig libpng zlib lcms2 ];

  preInstall = ''
    mkdir -p $out/bin
    export PREFIX=$out
  '';

  meta = with stdenv.lib; {
    homepage = https://pngquant.org/;
    description = "A tool to convert 24/32-bit RGBA PNGs to 8-bit palette with alpha channel preserved";
    platforms = platforms.linux;
    license = licenses.bsd2; # Not exactly bsd2, but alike
  };
}
