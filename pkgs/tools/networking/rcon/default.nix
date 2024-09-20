{ lib, stdenv, fetchFromGitHub, cmake, pkg-config, glib, libbsd, check, pcre }:

stdenv.mkDerivation rec {
  pname = "rcon";
  version = "0.6";

  src = fetchFromGitHub {
    owner = "n0la";
    repo = "rcon";
    rev = version;
    sha256 = "sha256-bHm6JeWmpg42VZQXikHl+BMx9zimRLBQWemTqOxyLhw=";
  };

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [
    glib
    libbsd
    check
    pcre
  ];

  meta = with lib; {
    homepage = "https://github.com/n0la/rcon";
    description = "Source RCON client for command line";
    maintainers = with maintainers; [ f4814n ];
    platforms = with platforms; linux ++ darwin;
    license = licenses.bsd2;
    mainProgram = "rcon";
  };
}
