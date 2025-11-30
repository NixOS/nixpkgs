{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "torrent-parser";
  version = "0.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "7sDream";
    repo = "torrent_parser";
    rev = "v${version}";
    hash = "sha256-zM738r3o9dGZYoWLN7fM4E06m6YPcAODEkgDS6wU/Sc=";
  };

  nativeBuildInputs = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "torrent_parser" ];

  meta = {
    description = ".torrent file parser and creator for both Python 2 and 3";
    mainProgram = "pytp";
    homepage = "https://github.com/7sDream/torrent_parser";
    changelog = "https://github.com/7sDream/torrent_parser/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
