{ lib, stdenv, fetchFromGitHub, pkg-config, libX11, perl, libXtst, xorgproto, libXi, libXinerama, libxkbcommon, libXext }:

stdenv.mkDerivation rec {
  pname = "xdotool";
  version = "3.20210804.2";

  src = fetchFromGitHub {
    owner = "jordansissel";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-7N5f/BFtq/m5MsXe7ZCTUTc1yp+JDJNRF1P9qB2l554=";
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
