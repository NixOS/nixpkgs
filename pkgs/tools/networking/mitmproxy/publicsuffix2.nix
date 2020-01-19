{ stdenv, buildPythonPackage, fetchPypi, python3Packages }:

buildPythonPackage rec {
  pname = "publicsuffix2";
  version = "2.20191221";

  checkInputs = [ python3Packages.requests ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "0yzysvfj1najr1mb4pcqrbmjir3xpb69rlffln95a3cdm8qwry00";
  };
}
