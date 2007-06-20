{stdenv, fetchurl, libX11, pkgconfig, xorgserver, libXi, libXext}:
stdenv.mkDerivation {
  name = "synaptics-0.14.6";

  src = fetchurl {
    url = http://web.telia.com/~u89404340/touchpad/files/synaptics-0.14.6.tar.bz2;
    md5 = "1102cd575045640a064ab6f9b1e391af";
  };

  makeFlags="DESTDIR=$out PREFIX=/";
  buildInputs = [libX11 pkgconfig xorgserver libXi libXext];
}
