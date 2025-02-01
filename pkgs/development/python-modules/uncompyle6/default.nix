{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  spark-parser,
  xdis,
  nose,
  pytest,
  hypothesis,
  six,
}:

buildPythonPackage rec {
  pname = "uncompyle6";
  version = "3.9.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-xFHDjrPFzINOuLip5uCwzzIm5NlNCP0nbdA/6RWO2yc=";
  };

  propagatedBuildInputs = [
    spark-parser
    xdis
  ];

  nativeCheckInputs = [
    nose
    pytest
    hypothesis
    six
  ];

  # Tests attempt to decompile bytecode of the python version
  # that is running the tests - this does not work for versions
  # above 3.8, but they decompile older bytecode fine
  doCheck = pythonOlder "3.9";
  # six import errors (yet it is supplied...)
  checkPhase = ''
    runHook preCheck
    pytest ./pytest --ignore=pytest/test_function_call.py
    runHook postCheck
  '';

  meta = with lib; {
    description = "Python cross-version byte-code deparser";
    homepage = "https://github.com/rocky/python-uncompyle6/";
    license = licenses.gpl3;
  };
}
