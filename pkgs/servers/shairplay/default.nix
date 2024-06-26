{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  avahi,
  libao,
}:

stdenv.mkDerivation rec {
  pname = "shairplay-unstable";
  version = "2018-08-24";

  src = fetchFromGitHub {
    owner = "juhovh";
    repo = "shairplay";
    rev = "096b61ad14c90169f438e690d096e3fcf87e504e";
    sha256 = "02xkd9al79pbqh8rhzz5w99vv43jg5vqkqg7kxsw8c8sz9di9wsa";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    avahi
    libao
  ];

  enableParallelBuilding = true;

  # the build will fail without complaining about a reference to /tmp
  preFixup = lib.optionalString stdenv.isLinux ''
    patchelf \
      --set-rpath "${lib.makeLibraryPath buildInputs}:$out/lib" \
      $out/bin/shairplay
  '';

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "Apple AirPlay and RAOP protocol server";
    license = licenses.mit;
    maintainers = with maintainers; [ peterhoeg ];
    platforms = platforms.unix;
    mainProgram = "shairplay";
  };
}
