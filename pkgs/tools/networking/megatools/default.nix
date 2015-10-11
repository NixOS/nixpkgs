{ stdenv, fetchurl, pkgconfig, glib, fuse, curl, glib_networking, gsettings_desktop_schemas
, makeWrapper }:

stdenv.mkDerivation rec {
  name = "megatools-${version}";
  version = "1.9.94";

  src = fetchurl {
    url = "http://megatools.megous.com/builds/${name}.tar.gz";
    sha256 = "1kms0k652sszcbzmx5nmz07gc8zbqqiskh8hvmvf6xaga7y3lgrx";
  };

  buildInputs = [ pkgconfig glib fuse curl makeWrapper
      gsettings_desktop_schemas ];

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
