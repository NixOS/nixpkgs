{ stdenv, fetchurl, glib, curl, pkgconfig, fuse, glib_networking, makeWrapper
, gsettings_desktop_schemas }:

stdenv.mkDerivation rec {
  name = "megatools-1.9.91";

  src = fetchurl {
    url = "http://megatools.megous.com/builds/${name}.tar.gz";
    sha256 = "0hb83wqsn6mggcmk871hl8cski5x0hxz9dhaka42115s4mdfbl1i";
  };

  buildInputs = [ glib curl pkgconfig fuse makeWrapper ];

  postInstall = ''
    for a in $out/bin/*; do
      wrapProgram "$a" \
            --prefix GIO_EXTRA_MODULES : "${glib_networking}/lib/gio/modules" \
            --prefix XDG_DATA_DIRS : "${gsettings_desktop_schemas}/share"

    done
  '';

  meta = {
    description = "Command line client for Mega.co.nz";
    homepage = http://megatools.megous.com/;
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = [ stdenv.lib.maintainers.viric ];
    platforms = stdenv.lib.platforms.linux;
  };
}
