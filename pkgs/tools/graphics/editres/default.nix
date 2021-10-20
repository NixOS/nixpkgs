{ lib, stdenv, fetchurl, pkg-config, libXt, libXaw, libXres, utilmacros }:

stdenv.mkDerivation rec {
  pname = "editres";
  version = "1.0.7";

  src = fetchurl {
    url = "mirror://xorg/individual/app/editres-${version}.tar.gz";
    sha256 = "10mbgijb6ac6wqb2grpy9mrazzw68jxjkxr9cbdf1111pa64yj19";
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
  };
}
