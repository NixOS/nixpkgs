{
  lib,
  stdenv,
  fetchFromGitHub,
  apacheHttpd,
  python3,
  ncurses,
}:

stdenv.mkDerivation rec {
  pname = "mod_wsgi";
  version = "5.0.1";

  src = fetchFromGitHub {
    owner = "GrahamDumpleton";
    repo = "mod_wsgi";
    rev = version;
    hash = "sha256-V0HefCwo6cXFs566NBybOyKGK7E7KxkthJD9k4C5hN8=";
  };

  buildInputs = [
    apacheHttpd
    python3
    ncurses
  ];

  postPatch = ''
    substituteInPlace configure --replace '/usr/bin/lipo' 'lipo'
  '';

  makeFlags = [
    "LIBEXECDIR=$(out)/modules"
  ];

  meta = {
    homepage = "https://github.com/GrahamDumpleton/mod_wsgi";
    description = "Host Python applications in Apache through the WSGI interface";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
  };
}
