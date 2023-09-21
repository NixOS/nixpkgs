{ fetchFromGitHub, lib, stdenv, autoreconfHook, intltool, pkg-config, libgnome, libgnomeui, GConf }:

stdenv.mkDerivation {
  pname = "gtetrinet";
  version = "0.7.11";

  src = fetchFromGitHub {
    owner = "GNOME";
    repo = "gtetrinet";
    rev = "6be3df83f3dc5c7cb966e6cd447182df01b93222";
    sha256 = "1y05x8lfyxvkjg6c87cfd0xxmb22c88scx8fq3gah7hjy5i42v93";
  };

  nativeBuildInputs = [ autoreconfHook intltool pkg-config ];

  buildInputs = [ libgnome libgnomeui ];

  propagatedUserEnvPkgs = [ GConf ];

  postAutoreconf = ''
    intltoolize --force
  '';

  preInstall = ''
    export GCONF_DISABLE_MAKEFILE_SCHEMA_INSTALL=1
  '';

  postInstall = ''
    mv "$out/games" "$out/bin"
  '';

  enableParallelBuilding = true;

  meta = {
    description = "Client for Tetrinet, a multiplayer online Tetris game";
    longDescription = ''
      GTetrinet is a client program for Tetrinet, a multiplayer tetris game
      that is played over the internet.
    '';
    homepage = "https://gtetrinet.sourceforge.net/";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.chris-martin ];
  };
}
