{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, setuptools-scm
, fsspec
}:

buildPythonPackage rec {
  pname = "universal-pathlib";
  version = "0.1.1";
  format = "pyproject";

  src = fetchPypi {
    pname = "universal_pathlib";
    inherit version;
    hash = "sha256-UhTIbyEP6rm+W8wALwQtZeruw8CTP9ZlpDNstw6GxZ0=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [
    fsspec
  ];

  pythonImportsCheck = [ "upath" ];

  meta = with lib; {
    description = "Pathlib api extended to use fsspec backends";
    homepage = "https://github.com/fsspec/universal_pathlib";
    changelog = "https://github.com/fsspec/universal_pathlib/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
