{ lib
, buildPythonPackage
, fetchFromGitHub

# build-system
, cython_3
, numpy
, oldest-supported-numpy
, setuptools
, setuptools-scm
, gnutar

# native
, libsoxr

# tests
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "soxr";
  version = "0.3.6";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "dofuuz";
    repo = "python-soxr";
    rev = "refs/tags/v${version}";
    fetchSubmodules = true;
    hash = "sha256-H2sueQq32o/9EHENANKVoiWlFoSF88P0LZ7DfEh/Esg=";
  };

  nativeBuildInputs = [
    cython_3
    gnutar
    numpy
    oldest-supported-numpy
    setuptools
    setuptools-scm
  ];

  pythonImportsCheck = [
    "soxr"
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "High quality, one-dimensional sample-rate conversion library";
    homepage = "https://github.com/dofuuz/python-soxr/tree/main";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ hexa ];
  };
}
