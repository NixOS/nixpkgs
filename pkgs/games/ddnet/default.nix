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
}:

stdenv.mkDerivation rec {
  pname = "ddnet";
  version = "15.6.2";

  src = fetchFromGitHub {
    owner = "ddnet";
    repo = pname;
    rev = version;
    sha256 = "sha256-nWouBe1qptDHedrSw5KDuGYyT7Bvf3cfwMynAfQALVY=";
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
    maintainers = with maintainers; [ sirseruju legendofmiracles ];
    mainProgram = "DDNet";
  };
}
