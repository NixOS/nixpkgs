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
  version = "5.0.0";

  src = fetchFromGitHub {
    owner = "GrahamDumpleton";
    repo = "mod_wsgi";
    rev = version;
    hash = "sha256-/4swm4AYCN3xyz2+OH7XqH/dFC53wqGPZgEAdxZQvbs=";
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
