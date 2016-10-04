{ stdenv, fetchurl, apacheHttpd, python }:

stdenv.mkDerivation rec {
  name = "mod_wsgi-${version}";
  version = "3.5";

  src = fetchurl {
    url = "https://github.com/GrahamDumpleton/mod_wsgi/archive/${version}.tar.gz";
    sha256 = "14xz422jlakdhxzsl8xs9if86yf1fnkwdg0havjyqs7my0w4qrzh";
  };

  buildInputs = [ apacheHttpd python ];

  patchPhase = ''
    sed -r -i -e "s|^LIBEXECDIR=.*$|LIBEXECDIR=$out/modules|" \
      ${if stdenv.isDarwin then "-e 's|/usr/bin/lipo|lipo|'" else ""} \
      configure
  '';

  meta = {
    homepage = http://code.google.com/p/modwsgi/;
    description = "Host Python applications in Apache through the WSGI interface";
    license = stdenv.lib.licenses.asl20;
    platforms = stdenv.lib.platforms.linux;
  };
}
