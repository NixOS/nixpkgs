{ stdenv, fetchurl, pkgconfig, libX11, perl, libXtst, xorgproto, libXi, libXinerama, libxkbcommon }:

stdenv.mkDerivation rec {
  name = "xdotool-${version}";
  version = "3.20160805.1";

  src = fetchurl {
    url = "https://github.com/jordansissel/xdotool/releases/download/v${version}/xdotool-${version}.tar.gz";
    sha256 = "1a6c1zr86zb53352yxv104l76l8x21gfl2bgw6h21iphxpv5zgim";
  };

  nativeBuildInputs = [ pkgconfig perl ];
  buildInputs = [ libX11 libXtst xorgproto libXi libXinerama libxkbcommon ];

  preBuild = ''
    mkdir -p $out/lib
  '';

  makeFlags = "PREFIX=$(out)";

  meta = {
    homepage = https://www.semicomplete.com/projects/xdotool/;
    description = "Fake keyboard/mouse input, window management, and more";
    license = stdenv.lib.licenses.bsd3;
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
