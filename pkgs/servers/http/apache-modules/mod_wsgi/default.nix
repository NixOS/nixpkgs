{ stdenv, fetchurl, apacheHttpd, python, ncurses }:

stdenv.mkDerivation rec {
  pname = "mod_wsgi";
  version = "4.7.1";

  src = fetchurl {
    url = "https://github.com/GrahamDumpleton/mod_wsgi/archive/${version}.tar.gz";
    sha256 = "0dbxhrp3x689ccrhvm2lw2icmmj8i4p86z2lq3xn1zlsf43fax16";
  };

  buildInputs = [ apacheHttpd python ncurses ];

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
