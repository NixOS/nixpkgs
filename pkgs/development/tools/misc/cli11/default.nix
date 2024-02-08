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
  version = "2.4.1";

  src = fetchFromGitHub {
    owner = "CLIUtils";
    repo = "CLI11";
    rev = "v${version}";
    sha256 = "sha256-YToHUAQtERVtM8lGPJnNilrYnXbuhlTWgwAITgR80c0=";
  };

  nativeBuildInputs = [ cmake ];

  nativeCheckInputs = [ boost python3 catch2 ];

  doCheck = true;

  meta = with lib; {
    description = "Command line parser for C++11";
    homepage = "https://github.com/CLIUtils/CLI11";
    platforms = platforms.unix;
    maintainers = with maintainers; [ ];
    license = licenses.bsd3;
  };

}
