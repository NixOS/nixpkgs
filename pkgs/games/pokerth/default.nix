{ stdenv, lib, fetchFromGitHub, qmake4Hook, qt4, protobuf, boost155, tinyxml2, libgcrypt, sqlite, gsasl, curl, SDL, SDL_mixer, libircclient }:

let boost = boost155;
in stdenv.mkDerivation rec {
  name            = "${pname}-${version}";
  pname           = "pokerth";
  version         = "1.1.1";

  src = fetchFromGitHub {
    owner  = pname;
    repo   = pname;
    rev    = "7f3c8a860848c16c8c2f78e3929a65a54ef4c04c";
    sha256 = "1md3sl7pdpn3n42k75pxqbkkl19cz4699g1vdi04qpp0jxx09a2k";
  };

  buildInputs = [ qmake4Hook qt4 protobuf boost tinyxml2 libgcrypt sqlite gsasl curl SDL SDL_mixer libircclient ];

  outputs = [ "out" "server" ];

  qmakeFlags = [ "pokerth.pro" ];

  NIX_CFLAGS_COMPILE = [ "-I${SDL.dev}/include/SDL" ];

  postPatch = ''
    for f in connectivity.pro load.pro pokerth_game.pro pokerth_server.pro
    do
      substituteInPlace $f \
        --replace 'LIB_DIRS =' 'LIB_DIRS = ${boost.out}/lib'
    done
  '';

  enableParallelBuilding = true;

  postInstall = ''
    install -D -m755 bin/pokerth_server $server/bin/pokerth_server
  '';

  meta = with stdenv.lib; {
    homepage    = http://www.pokerth.net/;
    description = "Open Source Poker client and server";
    license     = licenses.gpl3;
    maintainers = with maintainers; [ obadz ];
    platforms   = platforms.all;
  };
}
