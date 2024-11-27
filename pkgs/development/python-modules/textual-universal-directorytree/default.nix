{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  textual,
  universal-pathlib,
  adlfs,
  aiohttp,
  gcsfs,
  paramiko,
  requests,
  s3fs,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "textual-universal-directorytree";
  version = "1.5.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "juftin";
    repo = "textual-universal-directorytree";
    rev = "refs/tags/v${version}";
    hash = "sha256-hUig0aJWSS0FsgRIrs74/uVaQgH6tczJWO5rj6TVOvQ=";
  };

  nativeBuildInputs = [ hatchling ];

  propagatedBuildInputs = [
    textual
    universal-pathlib
  ];

  optional-dependencies = {
    remote = [
      adlfs
      aiohttp
      gcsfs
      paramiko
      requests
      s3fs
    ];
  };

  pythonImportsCheck = [ "textual_universal_directorytree" ];

  meta = with lib; {
    description = "Textual plugin for a DirectoryTree compatible with remote filesystems";
    homepage = "https://github.com/juftin/textual-universal-directorytree";
    changelog = "https://github.com/juftin/textual-universal-directorytree/releases/tag/${lib.removePrefix "refs/tags/" src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
