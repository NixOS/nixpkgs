{ lib, stdenv, fetchFromGitHub, cmake, zlib, openssl }:

stdenv.mkDerivation rec {
  pname = "unshield";
  version = "1.4.3";

  src = fetchFromGitHub {
    owner = "twogood";
    repo = "unshield";
    rev = version;
    sha256 = "19wn22vszhci8dfcixx5rliz7phx3lv5ablvhjlclvj75k2vsdqd";
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
