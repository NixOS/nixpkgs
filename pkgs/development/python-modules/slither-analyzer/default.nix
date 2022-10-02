{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, makeWrapper
, pythonOlder
, crytic-compile
, prettytable
, setuptools
, solc
, withSolc ? false
}:

buildPythonPackage rec {
  pname = "slither-analyzer";
  version = "0.8.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "crytic";
    repo = "slither";
    rev = version;
    sha256 = "sha256-Kh5owlkRB9hDlfIRiS+aNFe4YtZj38CLeE3Fe+R7diM=";
  };

  nativeBuildInputs = [
    makeWrapper
  ];

  propagatedBuildInputs = [
    crytic-compile
    prettytable
    setuptools
  ];

  postFixup = lib.optionalString withSolc ''
    wrapProgram $out/bin/slither \
      --prefix PATH : "${lib.makeBinPath [ solc ]}"
  '';

  # No Python tests
  doCheck = false;

  meta = with lib; {
    description = "Static Analyzer for Solidity";
    longDescription = ''
      Slither is a Solidity static analysis framework written in Python 3. It
      runs a suite of vulnerability detectors, prints visual information about
      contract details, and provides an API to easily write custom analyses.
    '';
    homepage = "https://github.com/trailofbits/slither";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ arturcygan fab ];
  };
}
