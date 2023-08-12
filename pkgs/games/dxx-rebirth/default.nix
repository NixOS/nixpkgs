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
  version = "unstable-2023-03-23";

  src = fetchFromGitHub {
    owner = "dxx-rebirth";
    repo = "dxx-rebirth";
    rev = "841ebcc11d249febe48911bc239606ade3bd78b3";
    hash = "sha256-cr5QdkKO/HNvtc2w4ynJixuLauhPCwtsSC3UEV7+C1A=";
  };

  nativeBuildInputs = [ pkg-config scons ];

  buildInputs = [ libGLU libGL libpng physfs SDL2 SDL2_image SDL2_mixer ];

  enableParallelBuilding = true;

  sconsFlags = [ "sdl2=1" ];

  env.NIX_CFLAGS_COMPILE = toString [
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
