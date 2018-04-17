{ stdenv, fetchurl, apacheHttpd, python2 }:

stdenv.mkDerivation rec {
  name = "mod_wsgi-${version}";
  version = "4.6.3";

  src = fetchurl {
    url = "https://github.com/GrahamDumpleton/mod_wsgi/archive/${version}.tar.gz";
    sha256 = "1vi2bf2spak70qqc1c673a7pwmzq01gmli43xwhrwdw7l2ig4wj9";
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
