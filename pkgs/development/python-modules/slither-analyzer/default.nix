{ lib
, stdenv
, buildPythonPackage
, crytic-compile
, fetchFromGitHub
, makeWrapper
, packaging
, prettytable
, pythonOlder
, setuptools
, solc
, web3
, withSolc ? false
}:

buildPythonPackage rec {
  pname = "slither-analyzer";
  version = "0.10.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "crytic";
    repo = "slither";
    rev = "refs/tags/${version}";
    hash = "sha256-MjO2ZYFat+byH0DEt2v/wPXaYL2lmlESgQCZXD4Jpt0=";
  };

  nativeBuildInputs = [
    makeWrapper
    setuptools
  ];

  propagatedBuildInputs = [
    crytic-compile
    packaging
    prettytable
    web3
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
    maintainers = with maintainers; [ arturcygan fab hellwolf ];
  };
}
