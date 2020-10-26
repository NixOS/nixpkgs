{ lib, buildPythonPackage, fetchPypi, makeWrapper, pythonOlder
, prettytable
, setuptools
, solc
}:

buildPythonPackage rec {
  pname = "slither-analyzer";
  version = "0.6.12";

  disabled = pythonOlder "3.6";

  # No Python tests
  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    sha256 = "9773cf48754341d03bb2e65c07897fc9c00a8727487ab2820ed89eb85f546506";
  };

  nativeBuildInputs = [ makeWrapper ];
  propagatedBuildInputs = [ prettytable setuptools ];

  postFixup = ''
    wrapProgram $out/bin/slither \
      --prefix PATH : "${lib.makeBinPath [ solc ]}"
  '';

  meta = with lib; {
    broken = true;
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
