{ stdenv, fetchFromGitHub
, SDL2, libpng, libjpeg, glew, openal, scons
}:

let
  version = "0.9.4";

in
stdenv.mkDerivation rec {
  name = "endless-sky-${version}";

  src = fetchFromGitHub {
    owner = "endless-sky";
    repo = "endless-sky";
    rev = "v${version}";
    sha256 = "1mirdcpap0a280j472lhmhqg605b7glvdr4l93qcapk8an8d46m7";
  };

  enableParallelBuilding = true;

  buildInputs = [
    SDL2 libpng libjpeg glew openal scons
  ];

  patches = [
    ./fixes.patch
  ];

  buildPhase = ''
    scons -j$NIX_BUILD_CORES PREFIX="$out"
  '';

  installPhase = ''
    scons -j$NIX_BUILD_CORES install PREFIX="$out"
  '';

  meta = with stdenv.lib; {
    description = "A sandbox-style space exploration game similar to Elite, Escape Velocity, or Star Control";
    homepage = "https://endless-sky.github.io/";
    license = with licenses; [
      gpl3Plus cc-by-sa-30 cc-by-sa-40 publicDomain
    ];
    maintainers = with maintainers; [ lheckemann ];
    platforms = with platforms; allBut darwin;
  };
}
