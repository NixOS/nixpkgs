{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  setuptools,
  setuptools-scm,
  pillow,
  pypdfium2,
  pytest-cov-stub,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "zebrafy";
  version = "1.2.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "miikanissi";
    repo = "zebrafy";
    tag = version;
    hash = "sha256-B8jrFQh5swDMfYjdMcY0Hh2VAzknDwarDKVAML6F2r4=";
  };

  patches = [
    # fix compatibility with pypdfium2 5.x: https://github.com/miikanissi/zebrafy/pull/20
    (fetchpatch {
      url = "https://github.com/miikanissi/zebrafy/pull/20/commits/cc15c4a28d9e8aec022d22397ff752600b9ede52.patch";
      hash = "sha256-KAjfKPqmTvfoQN7YPLayPyq2sueDASyU/lMCgLCl1RU=";
    })
  ];

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    pillow
    pypdfium2
  ];

  pythonImportsCheck = [ "zebrafy" ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
  ];

  meta = {
    description = "Python library for converting PDF and images to and from Zebra Programming Language";
    downloadPage = "https://github.com/miikanissi/zebrafy";
    changelog = "https://github.com/miikanissi/zebrafy/releases/tag/${version}";
    homepage = "https://zebrafy.readthedocs.io/en/latest/";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ ethancedwards8 ];
  };
}
