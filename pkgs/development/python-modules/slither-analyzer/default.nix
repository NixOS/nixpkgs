{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, makeWrapper
, pythonOlder
, crytic-compile
, prettytable
, setuptools
, solc
  # solc is currently broken on Darwin, default to false
, withSolc ? !stdenv.isDarwin
}:

buildPythonPackage rec {
  pname = "slither-analyzer";
  version = "0.8.0";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0b8a2e2145daefd9443ffa43639608203532e78a858af99c4c52c2b128ca681f";
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
