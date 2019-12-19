{ lib, buildPythonPackage, fetchPypi, makeWrapper, pythonOlder
, prettytable
, setuptools
, solc
}:

buildPythonPackage rec {
  pname = "slither-analyzer";
  version = "0.6.8";

  disabled = pythonOlder "3.6";

  # No Python tests
  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    sha256 = "8b3dda96f4938bbfc1d8a7775416dd480323603293c04212b59c5a35510d35c1";
  };

  nativeBuildInputs = [ makeWrapper ];
  propagatedBuildInputs = [ prettytable setuptools ];

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
