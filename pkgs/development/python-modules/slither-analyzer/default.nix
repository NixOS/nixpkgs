{ lib, buildPythonPackage, fetchPypi, makeWrapper, prettytable, pythonOlder, solc }:

buildPythonPackage rec {
  pname = "slither-analyzer";
  version = "0.3.0";

  disabled = pythonOlder "3.6";

  # No Python tests
  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    sha256 = "10vrcqm371kqmf702xmqmzimv3xgrn3k3ip06nr1l6gnj3jk138g";
  };

  nativeBuildInputs = [ makeWrapper ];
  propagatedBuildInputs = [ prettytable ];

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
    homepage = https://github.com/trailofbits/slither;
    license = licenses.agpl3;
    maintainers = [ maintainers.asymmetric ];
  };
}
