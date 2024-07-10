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
  version = "1.1.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "juftin";
    repo = "textual-universal-directorytree";
    rev = "refs/tags/v${version}";
    hash = "sha256-ncQ3IRaZaCv1rMUWT9dkUKo6OAEC5pziMCM7adIBGWo=";
  };

  nativeBuildInputs = [ hatchling ];

  propagatedBuildInputs = [
    textual
    universal-pathlib
  ];

  passthru.optional-dependencies = {
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
    changelog = "https://github.com/juftin/textual-universal-directorytree/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
