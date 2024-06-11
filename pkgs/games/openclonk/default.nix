{ lib, stdenv, fetchurl, fetchFromGitHub, fetchDebianPatch, cmake, pkg-config
, SDL2, libvorbis, libogg, libjpeg, libpng, freetype, glew, tinyxml, openal, libepoxy
, curl
, freealut, readline, libb2, gcc-unwrapped
, enableSoundtrack ? false # Enable the "Open Clonk Soundtrack - Explorers Journey" by David Oerther
}:

let
  soundtrack_src = fetchurl {
    url = "http://www.openclonk.org/download/Music.ocg";
    sha256 = "1ckj0dlpp5zsnkbb5qxxfxpkiq76jj2fgj91fyf3ll7n0gbwcgw5";
  };
in stdenv.mkDerivation rec {
  version = "unstable-2023-10-30";
  pname = "openclonk";

  src = fetchFromGitHub {
    owner = "openclonk";
    repo = "openclonk";
    rev = "5275334a11ef7c23ce809f35d6b443abd91b415f";
    sha256 = "14x5b2rh739156l4072rbsnv9n862jz1zafi6ng158ja5fwl16l2";
  };

  patches = [
    (fetchDebianPatch {
      pname = "openclonk";
      version = "8.1";
      debianRevision = "3";
      patch = "system-libb2.patch";
      hash = "sha256-zuH6zxSQXRhnt75092Xwb6XYv8UG391E5Arbnr7ApiI=";
    })
  ];

  enableParallelInstalling = false;

  postInstall = ''
  '' + lib.optionalString enableSoundtrack ''
    ln -sv ${soundtrack_src} $out/share/games/openclonk/Music.ocg
  '';

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [
    SDL2 libvorbis libogg libjpeg libpng freetype glew tinyxml openal freealut
    libepoxy curl
    readline libb2
  ];

  cmakeFlags = [ "-DCMAKE_AR=${gcc-unwrapped}/bin/gcc-ar" "-DCMAKE_RANLIB=${gcc-unwrapped}/bin/gcc-ranlib" ];

  cmakeBuildType = "RelWithDebInfo";

  meta = with lib; {
    description = "Free multiplayer action game in which you control clonks, small but witty and nimble humanoid beings";
    homepage = "https://www.openclonk.org";
    license = if enableSoundtrack then licenses.unfreeRedistributable else licenses.isc;
    mainProgram = "openclonk";
    maintainers = with maintainers; [ lheckemann ];
    platforms = [ "x86_64-linux" "i686-linux" ];
  };
}
