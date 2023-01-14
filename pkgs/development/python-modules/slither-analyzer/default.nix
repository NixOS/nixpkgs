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
  version = "0.9.1";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "crytic";
    repo = "slither";
    rev = "refs/tags/${version}";
    hash = "sha256-u9uA4eq6gYQXHhZ1ruk1vkEIRTKsgN87zENuR1Fhew4=";
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
    changelog = "https://github.com/crytic/slither/releases/tag/${version}";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ arturcygan fab ];
  };
}
