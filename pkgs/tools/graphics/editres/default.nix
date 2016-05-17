{ stdenv, fetchurl, pkgconfig, libXt, libXaw, libXres, utilmacros }:

stdenv.mkDerivation rec {
  name = "editres-1.0.6";

  src = fetchurl {
    url = "mirror://xorg/individual/app/${name}.tar.gz";
    sha256 = "06kv7dmw6pzlqc46dbh8k9xpb6sn4ihh0bcpxq0zpvw2lm66dx45";
  };

  buildInputs = [ pkgconfig libXt libXaw libXres utilmacros ];

  preConfigure = "configureFlags=--with-appdefaultdir=$out/share/X11/app-defaults/editres";

  meta = {
    homepage = "http://cgit.freedesktop.org/xorg/app/editres/";
    description = "a dynamic resource editor for X Toolkit applications";

    platforms = stdenv.lib.platforms.linux;
  };
}
