{ lib, stdenv, fetchurl, pkg-config, libXt, libXaw, libXres, utilmacros }:

stdenv.mkDerivation rec {
  pname = "editres";
  version = "1.0.8";

  src = fetchurl {
    url = "mirror://xorg/individual/app/editres-${version}.tar.gz";
    sha256 = "sha256-LVbWB3vHZ6+n4DD+ssNy/mvok/7EApoj9FodVZ/YRq4=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libXt libXaw libXres utilmacros ];

  configureFlags = [ "--with-appdefaultdir=$(out)/share/X11/app-defaults/editres" ];

  hardeningDisable = [ "format" ];

  meta = with lib; {
    homepage = "https://cgit.freedesktop.org/xorg/app/editres/";
    description = "A dynamic resource editor for X Toolkit applications";
    license = licenses.mit;
    platforms = platforms.linux;
    mainProgram = "editres";
  };
}
