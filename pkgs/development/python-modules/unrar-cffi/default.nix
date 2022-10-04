{ lib
, buildPythonPackage
, fetchPypi
, setuptools-scm
, pytest-runner
, cffi
}:

buildPythonPackage rec {
  pname = "unrar-cffi";
  version = "0.2.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-nebZB8ByhyS+B6z8tHnq3yaS8QOcp88t8mirtd+vS10=";
  };

  doCheck = false;
  propagatedBuildInputs = [
    setuptools-scm
    pytest-runner
    cffi
  ];

  meta = with lib; {
    homepage = "https://github.com/keredson/wordninja";
    description = "unrar library functionality through a zipfile-like interface";
    license = licenses.asl20;
  };
}
