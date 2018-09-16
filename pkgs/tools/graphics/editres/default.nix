{ stdenv, fetchurl, pkgconfig, libXt, libXaw, libXres, utilmacros }:

stdenv.mkDerivation rec {
  name = "editres-1.0.7";

  src = fetchurl {
    url = "mirror://xorg/individual/app/${name}.tar.gz";
    sha256 = "10mbgijb6ac6wqb2grpy9mrazzw68jxjkxr9cbdf1111pa64yj19";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libXt libXaw libXres utilmacros ];

  configureFlags = [ "--with-appdefaultdir=$(out)/share/X11/app-defaults/editres" ];

  hardeningDisable = [ "format" ];

  meta = with stdenv.lib; {
    homepage = https://cgit.freedesktop.org/xorg/app/editres/;
    description = "A dynamic resource editor for X Toolkit applications";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
