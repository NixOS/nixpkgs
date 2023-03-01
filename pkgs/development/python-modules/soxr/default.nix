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
  version = "0.3.3";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "dofuuz";
    repo = "python-soxr";
    rev = "refs/tags/v${version}";
    hash = "sha256-Kpw+KeXkkZlNLq8BMNMKtgBxe5Wb71jNaXZFmjjP34o=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    cython_3
    gnutar
    numpy
    setuptools
    setuptools-scm
  ];

  postPatch = ''
    tar -xf ${libsoxr.src} -C libsoxr
    mv libsoxr/soxr-*/* libsoxr/
  '';

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
