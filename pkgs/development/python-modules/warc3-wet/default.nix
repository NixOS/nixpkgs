{
  lib,
  buildPythonPackage,
  setuptools,
  wheel,
  pytest,
  fetchFromGitHub,
}:
buildPythonPackage {
  pname = "warc3-wet";
  version = "unstable-2024-07-17";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Willian-Zhang";
    repo = "warc3";
    rev = "a882c486c2bd1a0768713cdb89bdb879d8b966d5";
    hash = "sha256-YR8JOrWPKagvMl8YOeG/OgozzyMQm8BfvwwYI9Xh5EI=";
  };

  build-system = [
    setuptools
    wheel
  ];

  dependencies = [
    pytest
  ];

  pythonImportsCheck = [
    "warc"
  ];

  meta = {
    description = "Python 3 library for reading and writing warc files";
    homepage = "https://github.com/Willian-Zhang/warc3";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ gurjaka ];
    mainProgram = "warc";
  };
}
