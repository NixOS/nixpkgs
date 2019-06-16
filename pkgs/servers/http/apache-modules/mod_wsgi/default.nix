{ stdenv, fetchurl, apacheHttpd, python2 }:

stdenv.mkDerivation rec {
  name = "mod_wsgi-${version}";
  version = "4.6.6";

  src = fetchurl {
    url = "https://github.com/GrahamDumpleton/mod_wsgi/archive/${version}.tar.gz";
    sha256 = "1ic5lafqlwpld5jz2irj3yws883xhxldjyyh514w1lad1v085sbq";
  };

  buildInputs = [ apacheHttpd python2 ];

  patchPhase = ''
    sed -r -i -e "s|^LIBEXECDIR=.*$|LIBEXECDIR=$out/modules|" \
      ${if stdenv.isDarwin then "-e 's|/usr/bin/lipo|lipo|'" else ""} \
      configure
  '';

  meta = {
    homepage = https://github.com/GrahamDumpleton/mod_wsgi;
    description = "Host Python applications in Apache through the WSGI interface";
    license = stdenv.lib.licenses.asl20;
    platforms = stdenv.lib.platforms.linux;
  };
}
