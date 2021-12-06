{ lib, stdenv, fetchFromGitHub, cmake, zlib, openssl }:

stdenv.mkDerivation rec {
  pname = "unshield";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "twogood";
    repo = "unshield";
    rev = version;
    sha256 = "sha256-RUGcp6KagDSxeTTssz8tEYix75wFq60MV7Hoh9IPa0A=";
  };


  nativeBuildInputs = [ cmake ];
  buildInputs = [ zlib openssl ];

  meta = with lib; {
    description = "Tool and library to extract CAB files from InstallShield installers";
    homepage = "https://github.com/twogood/unshield";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
