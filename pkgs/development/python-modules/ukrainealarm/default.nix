{ lib
, buildPythonPackage
, fetchFromGitHub

# build time
, setuptools-scm

# propagates
, aiohttp

# tests
, pytestCheckHook
}:

let
  pname = "ukrainealarm";
  version = "0.0.1";
in

buildPythonPackage {
  inherit pname version;
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "PaulAnnekov";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-0gsxXQiSkJIM/I0VYsjdCCB3NjPr6QJbD/rBkGrwtW8=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    aiohttp
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "ukrainealarm"
    "ukrainealarm.client"
  ];

  meta = with lib; {
    changelog = "https://github.com/PaulAnnekov/ukrainealarm/releases/tag/v${version}";
    description = "Implements api.ukrainealarm.com API that returns info about Ukraine air raid alarms";
    homepage = "https://github.com/PaulAnnekov/ukrainealarm";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}

