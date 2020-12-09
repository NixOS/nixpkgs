{ lib, buildPythonPackage, fetchPypi, makeWrapper, pythonOlder
, crytic-compile, prettytable, setuptools, solc
}:

buildPythonPackage rec {
  pname = "slither-analyzer";
  version = "0.6.14";

  disabled = pythonOlder "3.6";

  # No Python tests
  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    sha256 = "79f5098d27c149ca9cce2b8008ed29e2e0c8cee8fa3414c7e5455cb73c90a9a8";
  };

  nativeBuildInputs = [ makeWrapper ];
  propagatedBuildInputs = [ crytic-compile prettytable setuptools ];

  postFixup = ''
    wrapProgram $out/bin/slither \
      --prefix PATH : "${lib.makeBinPath [ solc ]}"
  '';

  meta = with lib; {
    description = "Static Analyzer for Solidity";
    longDescription = ''
      Slither is a Solidity static analysis framework written in Python 3. It
      runs a suite of vulnerability detectors, prints visual information about
      contract details, and provides an API to easily write custom analyses.
    '';
    homepage = "https://github.com/trailofbits/slither";
    license = licenses.agpl3;
    maintainers = [ maintainers.asymmetric ];
  };
}
