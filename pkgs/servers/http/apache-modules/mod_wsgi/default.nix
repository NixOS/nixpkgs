{ lib, stdenv, fetchFromGitHub, apacheHttpd, python, ncurses }:

stdenv.mkDerivation rec {
  pname = "mod_wsgi";
  version = "4.9.4";

  src = fetchFromGitHub {
    owner = "GrahamDumpleton";
    repo = "mod_wsgi";
    rev = version;
    hash = "sha256-6rRHdgdTb94kqIpWJOJOwoIsaXb/c4XY3q331GwQyf0=";
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
    platforms = lib.platforms.unix;
  };
}
