{ lib
, buildPythonPackage
, fetchFromGitHub

# build-sytem
, cython_3
, numpy
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
  version = "0.3.4";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "dofuuz";
    repo = "python-soxr";
    rev = "refs/tags/v${version}";
    fetchSubmodules = true;
    hash = "sha256-/NFGzOF1X9c0yccgtVNUO+1aIWoNdJqP/OKcNj+uKpk=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    cython_3
    gnutar
    numpy
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
