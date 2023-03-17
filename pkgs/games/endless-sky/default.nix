{ lib, stdenv, fetchFromGitHub
, SDL2, libpng, libjpeg, glew, openal, scons, libmad, libuuid
}:

stdenv.mkDerivation rec {
  pname = "endless-sky";
  version = "0.9.16.1";

  src = fetchFromGitHub {
    owner = "endless-sky";
    repo = "endless-sky";
    rev = "v${version}";
    sha256 = "sha256-bohljxAtSVqsfnge6t4LF3pC1s1r99v3hNLKTBquC20=";
  };

  patches = [
    ./fixes.patch
  ];

  preBuild = ''
    export AR="${stdenv.cc.targetPrefix}gcc-ar"
  '';

  enableParallelBuilding = true;

  buildInputs = [
    SDL2 libpng libjpeg glew openal scons libmad libuuid
  ];

  prefixKey = "PREFIX=";

  meta = with lib; {
    description = "A sandbox-style space exploration game similar to Elite, Escape Velocity, or Star Control";
    homepage = "https://endless-sky.github.io/";
    license = with licenses; [
      gpl3Plus cc-by-sa-30 cc-by-sa-40 publicDomain
    ];
    maintainers = with maintainers; [ lheckemann ];
    platforms = platforms.linux; # Maybe other non-darwin Unix
  };
}
