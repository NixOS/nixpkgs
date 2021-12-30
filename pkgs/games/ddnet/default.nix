{ lib
, stdenv
, fetchFromGitHub
, cmake
, ninja
, pkg-config
, curl
, freetype
, libGLU
, libnotify
, libogg
, libX11
, opusfile
, pcre
, python3
, SDL2
, sqlite
, wavpack
, ddnet
, testVersion
}:

stdenv.mkDerivation rec {
  pname = "ddnet";
  version = "15.8";

  src = fetchFromGitHub {
    owner = "ddnet";
    repo = pname;
    rev = version;
    sha256 = "sha256-segJVGH5ngSEhk0EpLHPORTNck4tIDCxJh9Ri6sa2dE=";
  };

  nativeBuildInputs = [ cmake ninja pkg-config ];

  buildInputs = [
    curl
    freetype
    libGLU
    libnotify
    libogg
    libX11
    opusfile
    pcre
    python3
    SDL2
    sqlite
    wavpack
  ];

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
    "-DAUTOUPDATE=OFF"
    "-GNinja"
  ];

  postPatch = ''
    substituteInPlace src/engine/shared/storage.cpp \
      --replace /usr/ $out/
  '';

  passthru.tests.version = testVersion { package = ddnet; };

  meta = with lib; {
    description = "A Teeworlds modification with a unique cooperative gameplay.";
    longDescription = ''
      DDraceNetwork (DDNet) is an actively maintained version of DDRace,
      a Teeworlds modification with a unique cooperative gameplay.
      Help each other play through custom maps with up to 64 players,
      compete against the best in international tournaments,
      design your own maps, or run your own server.
    '';
    homepage = "https://ddnet.tw";
    license = licenses.asl20;
    maintainers = with maintainers; [ sirseruju lom ];
    mainProgram = "DDNet";
  };
}
