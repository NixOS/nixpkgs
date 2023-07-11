{ lib
, buildPythonPackage
, fetchFromGitHub
, hatchling
, textual
, universal-pathlib
, adlfs
, aiohttp
, gcsfs
, paramiko
, requests
, s3fs
}:

buildPythonPackage rec {
  pname = "textual-universal-directorytree";
  version = "1.0.1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "juftin";
    repo = "textual-universal-directorytree";
    rev = "v${version}";
    hash = "sha256-a7alxVmHTKJnJiU7X6UlUD2y7MY4O5TMR+02KcyPwEs=";
  };

  nativeBuildInputs = [
    hatchling
  ];

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
