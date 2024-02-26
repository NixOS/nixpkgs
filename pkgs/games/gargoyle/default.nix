{ lib, stdenv, fetchFromGitHub, cmake, qtbase, wrapQtAppsHook,
  pkg-config, SDL2, SDL2_mixer }:

stdenv.mkDerivation rec {
  pname = "gargoyle";
  version = "ce4c985a03553321fe7470621f32443e0eb118c4";

  src = fetchFromGitHub {
    owner = "garglk";
    repo = "garglk";
    rev = version;
    sha256 = "sha256-fAW4dsuHnMhFJXqpgUhlYaMey9RWVi/AsMyEAN1IMKc=";
  };

  nativeBuildInputs = [ cmake pkg-config wrapQtAppsHook ];

  buildInputs = [ qtbase SDL2 SDL2_mixer ];

  enableParallelBuilding = true;

  meta = with lib; {
    broken = stdenv.isDarwin;
    homepage = "http://ccxvii.net/gargoyle/";
    license = licenses.gpl2Plus;
    description = "Interactive fiction interpreter GUI";
    platforms = platforms.unix;
    maintainers = with maintainers; [ orivej ];
  };
}
