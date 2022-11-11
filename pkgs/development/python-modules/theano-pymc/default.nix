{ lib
, fetchPypi
, buildPythonPackage
, pythonOlder
, pandas
, numpy
, scipy
, filelock
, pytest
, nose
, parameterized
}:

buildPythonPackage rec {
  pname = "theano-pymc";
  version = "1.1.2";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    pname = "Theano-PyMC";
    inherit version;
    sha256 = "5da6c2242ea72a991c8446d7fe7d35189ea346ef7d024c890397011114bf10fc";
  };

  # No need for coverage stats in Nix builds
  postPatch = ''
    substituteInPlace setup.py --replace ", 'pytest-cov'" ""
  '';

  propagatedBuildInputs = [
    pandas
    numpy
    scipy
    filelock
  ];

  # The test suite is computationally intensive and test failures are not
  # indicative for package usability hence tests are disabled by default.
  doCheck = false;
  pythonImportsCheck = [ "theano" ];

  meta = {
    description = "PyMC theano fork";
    homepage = "https://github.com/majidaldo/Theano-PyMC";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nidabdella ];
  };
}
