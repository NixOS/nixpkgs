{ stdenv, fetchurl, pkgconfig, glib, fuse, curl, glib_networking, gsettings_desktop_schemas
, makeWrapper }:

stdenv.mkDerivation rec {
  name = "megatools-${version}";
  version = "1.9.93";

  src = fetchurl {
    url = "http://megatools.megous.com/builds/${name}.tar.gz";
    sha256 = "0xm57pgjvfifq1j5lyvrcs6x0vxhqzr399s7paj4g7nspj0dbll9";
  };

  buildInputs = [ pkgconfig glib fuse curl makeWrapper ];

  postInstall = ''
    for i in $(find $out/bin/ -type f); do
      wrapProgram "$i" \
            --prefix GIO_EXTRA_MODULES : "${glib_networking}/lib/gio/modules" \
            --prefix XDG_DATA_DIRS : "${gsettings_desktop_schemas}/share"
    done
  '';

  meta = with stdenv.lib; {
    description = "Command line client for Mega.co.nz";
    homepage = http://megatools.megous.com/;
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.viric maintainers.AndersonTorres ];
    platforms = platforms.linux;
  };
}
