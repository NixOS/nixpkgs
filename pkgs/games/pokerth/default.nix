{ stdenv, fetchFromGitHub, qmake4Hook, qt4, protobuf, boost155, tinyxml2, libgcrypt, sqlite, gsasl, curl, SDL, SDL_mixer, libircclient }:

let boost = boost155;
in stdenv.mkDerivation rec {
  name            = "${pname}-${version}";
  pname           = "pokerth";
  version         = "1.1.2";

  src = fetchFromGitHub {
    owner  = pname;
    repo   = pname;
    rev    = "v${version}";
    sha256 = "0m74jyd9h3yaly3avy65zw7r2iv5b62c2dqizbxsagjsr9a3g0cg";
  };

  buildInputs = [ qmake4Hook qt4 protobuf boost tinyxml2 libgcrypt sqlite gsasl curl SDL SDL_mixer libircclient ];

  outputs = [ "out" "server" ];

  qmakeFlags = [ "pokerth.pro" "DEFINES+=_WEBSOCKETPP_NOEXCEPT_TOKEN_=noexcept" ];

  NIX_CFLAGS_COMPILE = [ "-I${SDL.dev}/include/SDL" ];

  postPatch = ''
    for f in connectivity.pro load.pro pokerth_game.pro pokerth_server.pro
    do
      substituteInPlace $f \
        --replace 'LIB_DIRS =' 'LIB_DIRS = ${boost.out}/lib' \
        --replace '/opt/gsasl/' '${gsasl}/'
    done
    substituteInPlace pokerth_server.pro --replace '$$'{PREFIX}/include/libircclient '${libircclient.dev}/include/libircclient'
  '';

  enableParallelBuilding = true;

  postInstall = ''
    install -D -m755 bin/pokerth_server $server/bin/pokerth_server
  '';

  meta = with stdenv.lib; {
    homepage    = https://www.pokerth.net;
    description = "Open Source Poker client and server";
    license     = licenses.gpl3;
    maintainers = with maintainers; [ obadz ];
    platforms   = platforms.all;
  };
}
