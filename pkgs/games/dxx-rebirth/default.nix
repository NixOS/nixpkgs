{ lib, stdenv
, fetchFromGitHub
, fetchurl
, fetchpatch
, scons
, pkg-config
, SDL2
, SDL2_image
, SDL2_mixer
, libGLU
, libGL
, libpng
, physfs
}:

let
  music = fetchurl {
    url = "https://www.dxx-rebirth.com/download/dxx/res/d2xr-sc55-music.dxa";
    sha256 = "05mz77vml396mff43dbs50524rlm4fyds6widypagfbh5hc55qdc";
  };

in
stdenv.mkDerivation rec {
  pname = "dxx-rebirth";
  version = "unstable-2022-09-17";

  src = fetchFromGitHub {
    owner = "dxx-rebirth";
    repo = "dxx-rebirth";
    rev = "ad46235b67a24a38dec4734f94a59eba149ad94a";
    hash = "sha256-vIAY1O4VnOsV617J5yjg09JIL/vK4Fb/lopnX17g+uY=";
  };

  nativeBuildInputs = [ pkg-config scons ];

  buildInputs = [ libGLU libGL libpng physfs SDL2 SDL2_image SDL2_mixer ];

  enableParallelBuilding = true;

  sconsFlags = [ "sdl2=1" ];

  NIX_CFLAGS_COMPILE = [
    "-Wno-format-nonliteral"
    "-Wno-format-truncation"
  ];

  postInstall = ''
    install -Dm644 ${music} $out/share/games/dxx-rebirth/${music.name}
    install -Dm644 -t $out/share/doc/dxx-rebirth *.txt
  '';

  meta = with lib; {
    description = "Source Port of the Descent 1 and 2 engines";
    homepage = "https://www.dxx-rebirth.com/";
    license = licenses.gpl3;
    maintainers = with maintainers; [ peterhoeg ];
    platforms = with platforms; linux;
  };
}
