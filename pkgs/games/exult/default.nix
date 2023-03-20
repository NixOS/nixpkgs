{ lib
, stdenv
, fetchFromGitHub
, SDL2
, autoconf
, automake
, libogg
, libtool
, libvorbis
, pkg-config
, zlib
, enableTools ? false
}:

stdenv.mkDerivation rec {
  pname = "exult";
  version = "1.8";

  src = fetchFromGitHub {
    owner = "exult";
    repo = "exult";
    rev = "v${version}";
    hash = "sha256-Y7FpgiGuqR4ZG/PNSfLcNcRWeeC7GebUTighXsCfy+E=";
  };

  nativeBuildInputs = [
    autoconf
    automake
    libtool
    pkg-config
  ];

  buildInputs = [
    SDL2
    libogg
    libvorbis
    zlib
  ];

  preConfigure = ''
    ./autogen.sh
  '';

  configureFlags = lib.optional (!enableTools) "--disable-tools";

  meta = with lib; {
    description = "Exult is a project to recreate Ultima VII for modern operating systems";
    longDescription = ''
      Ultima VII, an RPG from the early 1990's, still has a huge following. But,
      being a DOS game with a very nonstandard memory manager, it is difficult
      to run it on the latest computers. Exult is a project that created an
      Ultima VII game engine that runs on modern operating systems, capable of
      using the data and graphics files that come with the game. Exult aims to
      let those people who own Ultima VII play the game on modern hardware, in
      as close to (or perhaps even surpassing) its original splendor as is
      possible.
    '';
    homepage = "http://exult.info";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ azahi eelco ];
  };
}
