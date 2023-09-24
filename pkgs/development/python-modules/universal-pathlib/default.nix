{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, setuptools
, setuptools-scm
, fsspec
}:

buildPythonPackage rec {
  pname = "universal-pathlib";
  version = "0.1.3";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "universal_pathlib";
    inherit version;
    hash = "sha256-GgUqteBRcwHfZr5lF+n+Y82fwAgT5c5xpzcBRBrCtcg=";
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
