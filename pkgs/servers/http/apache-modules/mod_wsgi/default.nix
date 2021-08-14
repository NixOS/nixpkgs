{ lib, stdenv, fetchurl, apacheHttpd, python, ncurses }:

stdenv.mkDerivation rec {
  pname = "mod_wsgi";
  version = "4.9.0";

  src = fetchurl {
    url = "https://github.com/GrahamDumpleton/mod_wsgi/archive/${version}.tar.gz";
    sha256 = "sha256-Cm84CvhUuFoxUeVKPDO1IMSm4hqZvK165d37/jGnS1A=";
  };

  buildInputs = [ apacheHttpd python ncurses ];

  patchPhase = ''
    sed -r -i -e "s|^LIBEXECDIR=.*$|LIBEXECDIR=$out/modules|" \
      ${if stdenv.isDarwin then "-e 's|/usr/bin/lipo|lipo|'" else ""} \
      configure
  '';

  meta = {
    homepage = "https://github.com/GrahamDumpleton/mod_wsgi";
    description = "Host Python applications in Apache through the WSGI interface";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
  };
}
