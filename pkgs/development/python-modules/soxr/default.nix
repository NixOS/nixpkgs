{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  cython,
  numpy,
  oldest-supported-numpy,
  setuptools,
  setuptools-scm,
  gnutar,

  # native
  libsoxr,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "soxr";
  version = "0.3.7";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "dofuuz";
    repo = "python-soxr";
    rev = "refs/tags/v${version}";
    fetchSubmodules = true;
    hash = "sha256-HGtoMfMQ5/2iEIFtik7mCrSxFnLXkSSx2W8wBul0+jk=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "SYS_LIBSOXR = False" "SYS_LIBSOXR = True"
  '';

  nativeBuildInputs = [
    cython
    gnutar
    numpy
    oldest-supported-numpy
    setuptools
    setuptools-scm
  ];

  buildInputs = [ libsoxr ];

  pythonImportsCheck = [ "soxr" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "High quality, one-dimensional sample-rate conversion library";
    homepage = "https://github.com/dofuuz/python-soxr/tree/main";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ hexa ];
  };
}
