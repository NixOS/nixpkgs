{ stdenv, fetchurl, pkgconfig, glib, fuse, curl, glib_networking, gsettings_desktop_schemas
, asciidoc, makeWrapper }:

stdenv.mkDerivation rec {
  name = "megatools-${version}";
  version = "1.9.98";

  src = fetchurl {
    url = "http://megatools.megous.com/builds/${name}.tar.gz";
    sha256 = "0vx1farp0dpg4zwvxdbfdnzjk9qx3sn109p1r1zl3g3xsaj221cv";
  };

  buildInputs = [ pkgconfig glib fuse curl makeWrapper
      gsettings_desktop_schemas asciidoc ];

  postInstall = ''
    for i in $(find $out/bin/ -type f); do
      wrapProgram "$i" \
            --prefix GIO_EXTRA_MODULES : "${glib_networking.out}/lib/gio/modules" \
            --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH"
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
