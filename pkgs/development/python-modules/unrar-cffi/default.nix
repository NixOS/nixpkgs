{ lib
, buildPythonPackage
, fetchPypi
, cffi
, setuptools
, setuptools-scm
, pytest-runner
}:

buildPythonPackage rec {
  pname = "unrar-cffi";
  version = "0.2.2";
  format = "pyproject";
  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-nebZB8ByhyS+B6z8tHnq3yaS8QOcp88t8mirtd+vS10=";
  };
  propagatedBuildInputs = [
    cffi
    setuptools
    setuptools-scm
    pytest-runner
  ];
  meta = with lib; {
    description = "Read RAR file from python -- cffi edition";
    homepage = "https://github.com/davide-romanini/unrar-cffi";
    license = licenses.asl20;
    maintainers = with maintainers; [ provenzano ];
  };
}
