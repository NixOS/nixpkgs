{ stdenv, fetchurl, apacheHttpd, python2 }:

stdenv.mkDerivation rec {
  name = "mod_wsgi-${version}";
  version = "4.6.2";

  src = fetchurl {
    url = "https://github.com/GrahamDumpleton/mod_wsgi/archive/${version}.tar.gz";
    sha256 = "0gviv9x4w4i8d26d8vyrr8zk4p5hdx63rxpzqw769cmhvvy8r3g2";
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
