{ lib
, pkgs
, fetchPypi
, python
, buildPythonPackage
, pythonOlder
, numpy
, typing-extensions
, pytest-xdist
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "sox";
  version = "1.4.1";
  format = "setuptools";
  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    extension = "tar.gz";
    hash = "sha256-sPLRNpJFC4ic0/ZhJ+lvgBlC7CqsW7IWU9/RUODXEFU=";
  };

  nativeCheckInputs = [
    pytest-xdist
    pytestCheckHook
    pkgs.sox
  ];

  propagatedBuildInputs = [
    numpy
    typing-extensions
  ];

  # test failing
  doCheck = false;

  pythonImportsCheck = [ "sox" ];

  meta = with lib; {
    description = "Python wrapper around sox";
    homepage = "https://github.com/rabitt/pysox";
    license = licenses.bsd3;
    maintainers = with maintainers; [ FaustXVI ];
  };
}
