{
  lib,
  buildPythonPackage,
  setuptools,
  fetchFromGitHub,
  pytestCheckHook,
}:
buildPythonPackage {
  pname = "warc3-wet";
  version = "0.2.5-unstable-2024-07-17";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Willian-Zhang";
    repo = "warc3";
    rev = "a882c486c2bd1a0768713cdb89bdb879d8b966d5"; # no tags
    hash = "sha256-YR8JOrWPKagvMl8YOeG/OgozzyMQm8BfvwwYI9Xh5EI=";
  };

  build-system = [
    setuptools
  ];

  pythonImportsCheck = [
    "warc"
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Python 3 library for reading and writing warc files";
    homepage = "https://github.com/Willian-Zhang/warc3";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ gurjaka ];
  };
}
