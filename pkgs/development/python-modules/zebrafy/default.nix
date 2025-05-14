{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
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
