{
  buildPythonPackage,
  lib,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "sniffio";
  version = "1.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "python-trio";
    repo = "sniffio";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Hp3i0NP57Z0OvLzRxu9+kiWF0+ye8y7J4HZoxeherv0=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    homepage = "https://github.com/python-trio/sniffio";
    changelog = "https://github.com/python-trio/sniffio/blob/${finalAttrs.src.tag}/docs/source/history.rst";
    license = lib.licenses.asl20;
    description = "Sniff out which async library your code is running under";
  };
})
