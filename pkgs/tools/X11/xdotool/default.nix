{ lib, stdenv, fetchFromGitHub, pkg-config, libX11, perl, libXtst, xorgproto, libXi, libXinerama, libxkbcommon, libXext }:

stdenv.mkDerivation rec {
  pname = "xdotool";
  version = "3.20210903.1";

  src = fetchFromGitHub {
    owner = "jordansissel";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-fmz/CJm1GgNOYjOfC6uNwDa8jV+GczPw8m6Qb2jw3rE=";
  };

  nativeBuildInputs = [ pkg-config perl ];
  buildInputs = [ libX11 libXtst xorgproto libXi libXinerama libxkbcommon libXext ];

  preBuild = ''
    mkdir -p $out/lib
  '';

  makeFlags = [ "PREFIX=$(out)" ];

  meta = {
    homepage = "https://www.semicomplete.com/projects/xdotool/";
    description = "Fake keyboard/mouse input, window management, and more";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [viric];
    platforms = with lib.platforms; linux;
  };
}
