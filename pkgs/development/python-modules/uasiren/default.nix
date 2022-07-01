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
  pname = "uasiren";
  version = "0.0.1";
in

buildPythonPackage {
  inherit pname version;
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "PaulAnnekov";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-NHrnG5Vhz+JZgcTJyfIgGz0Ye+3dFVv2zLCCqw2++oM=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    aiohttp
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "uasiren"
    "uasiren.client"
  ];

  meta = with lib; {
    changelog = "https://github.com/PaulAnnekov/uasiren/releases/tag/v${version}";
    description = "Implements siren.pp.ua API - public wrapper for api.ukrainealarm.com API that returns info about Ukraine air-raid alarms";
    homepage = "https://github.com/PaulAnnekov/uasiren";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}

