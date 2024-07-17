{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "pixiewps";
  version = "1.4.2";
  src = fetchFromGitHub {
    owner = "wiire-a";
    repo = "pixiewps";
    rev = "v${version}";
    sha256 = "sha256-cJ20Gp6YaSdgUXK/ckK5Yv0rGbGXuFMP5zKZG0c4oOY=";
  };

  preBuild = ''
    substituteInPlace Makefile --replace "/usr/local" "$out"
  '';

  meta = {
    description = "An offline WPS bruteforce utility";
    homepage = "https://github.com/wiire-a/pixiewps";
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.nico202 ];
    platforms = lib.platforms.all;
    mainProgram = "pixiewps";
  };
}
