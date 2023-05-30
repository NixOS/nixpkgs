{ lib
, pkgs
, stdenv
, fetchFromGitHub
, perl
, cmake }:

stdenv.mkDerivation rec {
  pname = "dynamorio";
  version = "9.90.19402";

  src = fetchFromGitHub {
    owner = "DynamoRIO";
    repo = "dynamorio";
    rev = "cronbuild-${version}";
    sha256 = "sha256-f+M8RaTZwM5/SmYc1H4wEjX1KrdNerqN8LUWlJgLe+E=";
  };

  nativeBuildInputs = [ cmake perl ];
  buildInputs = [ ];
  enableParallelBuilding = true;

  outputs = [ "out" ];

  meta = with lib; {
    description = "Dynamic Instrumentation Tool Platform";
    homepage = "https://dynamorio.org/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ oposs ];
  };
}
