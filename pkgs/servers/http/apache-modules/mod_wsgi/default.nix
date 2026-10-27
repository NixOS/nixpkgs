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
  version = "5.0.2";

  src = fetchFromGitHub {
    owner = "GrahamDumpleton";
    repo = "mod_wsgi";
    rev = version;
    hash = "sha256-FhOSU8/4QoWa73bNi/qkgKm3CeEEdboh2MgxgQxcYzE=";
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
