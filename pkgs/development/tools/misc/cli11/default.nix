{ lib
, stdenv
, fetchFromGitHub
, boost
, catch2
, cmake
, gtest
, python3
}:

stdenv.mkDerivation rec {
  pname = "cli11";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "CLIUtils";
    repo = "CLI11";
    rev = "v${version}";
    sha256 = "sha256-emTIaoUyTINbAAn9tw1r3zLTQt58N8A1zoP+0y41yKo=";
  };

  nativeBuildInputs = [ cmake ];

  checkInputs = [ boost python3 catch2 ];

  doCheck = true;

  meta = with lib; {
    description = "Command line parser for C++11";
    homepage = "https://github.com/CLIUtils/CLI11";
    platforms = platforms.unix;
    maintainers = with maintainers; [ ];
    license = licenses.bsd3;
  };

}
