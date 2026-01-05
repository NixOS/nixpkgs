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
  version = "1.7.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "juftin";
    repo = "textual-universal-directorytree";
    tag = "v${version}";
    hash = "sha256-e9i6P+KQnGbFwCsNiu2eLJFg3fpcR2/vl/FVWOBqWUQ=";
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
    changelog = "https://github.com/juftin/textual-universal-directorytree/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = [ ];
  };
}
