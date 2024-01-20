{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, hatchling
, textual
, universal-pathlib
, adlfs
, aiohttp
, gcsfs
, paramiko
, requests
, s3fs
, pythonOlder
}:

buildPythonPackage rec {
  pname = "textual-universal-directorytree";
  version = "1.0.2";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "juftin";
    repo = "textual-universal-directorytree";
    rev = "refs/tags/v${version}";
    hash = "sha256-FL2bwPGqBmDn33Rhj7+VEpuqB4znEAw+GGAODTs25oo=";
  };

  patches = [
    # universal-pathlib upgrade, https://github.com/juftin/textual-universal-directorytree/pull/2
    (fetchpatch {
      name = "universal-pathlib-upgrade.patch";
      url = "https://github.com/juftin/textual-universal-directorytree/commit/e445aff21ddf756e3f180c8308a75c41487667c3.patch";
      hash = "sha256-Fftx8rrLPb6lQ+HBdB5Ai55LHMWEO6XftmFfZXbXIyk=";
    })
  ];

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

  pythonImportsCheck = [
    "textual_universal_directorytree"
  ];

  meta = with lib; {
    description = "Textual plugin for a DirectoryTree compatible with remote filesystems";
    homepage = "https://github.com/juftin/textual-universal-directorytree";
    changelog = "https://github.com/juftin/textual-universal-directorytree/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
