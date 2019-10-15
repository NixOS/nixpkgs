{ stdenv, fetchurl, apacheHttpd, python, ncurses }:

stdenv.mkDerivation rec {
  pname = "mod_wsgi";
  version = "4.6.7";

  src = fetchurl {
    url = "https://github.com/GrahamDumpleton/mod_wsgi/archive/${version}.tar.gz";
    sha256 = "1j8pqn0xhd502ardlmkqx8y85s1npmk9nifqps60wjh29nny03f2";
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
