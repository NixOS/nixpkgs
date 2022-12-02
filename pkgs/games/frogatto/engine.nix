{ lib, stdenv, fetchFromGitHub, fetchurl, which
, boost, SDL2, SDL2_image, SDL2_mixer, SDL2_ttf
, glew, zlib, icu, pkg-config, cairo, libvpx }:

stdenv.mkDerivation {
  pname = "anura-engine";
  version = "unstable-2022-04-09";

  src = fetchFromGitHub {
    owner = "anura-engine";
    repo = "anura";
    rev = "5ac7f6fe63114274f0da7dad4c1ed673651e6424";
    sha256 = "1yrcbvzgxdvn893qk1qcpb53pjns366fdls5qjal7lhq71kkfc67";
    fetchSubmodules = true;
  };
  patches = [
    # https://github.com/anura-engine/anura/issues/321
    (fetchurl {
      url = "https://github.com/anura-engine/anura/commit/627d08fb5254b5c66d315f1706089905c2704059.patch";
      sha256 = "052m58qb3lg0hnxacpnjz2sz89dk0x6b5qi2q9bkzkvg38f237rr";
    })
  ];

  nativeBuildInputs = [
    which pkg-config
  ];

  buildInputs = [
    boost
    SDL2
    SDL2_image
    SDL2_mixer
    SDL2_ttf
    glew
    zlib
    icu
    cairo
    libvpx
  ];

  enableParallelBuilding = true;

  installPhase = ''
    mkdir -p $out/bin $out/share/frogatto
    cp -ar data images modules $out/share/frogatto/
    cp -a anura $out/bin/frogatto
  '';

  meta = with lib; {
    homepage = "https://github.com/anura-engine/anura";
    description = "Game engine used by Frogatto";
    license = licenses.zlib;
    platforms = platforms.linux;
    maintainers = with maintainers; [ astro ];
  };
}
