{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
  cachetools,
  gevent,
  gevent-eventemitter,
  mock,
  protobuf,
  pycryptodomex,
  pyyaml,
  requests,
  six,
  vcrpy,
  vdf,
  win-inet-pton,
}:
buildPythonPackage rec {
  pname = "steam";
  version = "1.4.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ValvePython";
    repo = "steam";
    rev = "v${version}";
    hash = "sha256-OY04GsX3KMPvpsQl8sUurzFyJu+JKpES8B0iD6Z5uyw=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    cachetools
    gevent
    gevent-eventemitter
    protobuf
    pycryptodomex
    requests
    six
    vdf
    win-inet-pton
  ];

  nativeCheckInputs = [
    mock
    vcrpy
    pyyaml
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "--ignore=tests/test_webapi.py"
    "--deselect=tests/test_steamid.py::steamid_functions::test_steam64_from_url"
  ];

  pythonImportsCheck = [
    "steam"
    "steam.client"
    "steam.core"
    "steam.enums"
    "steam.exceptions"
    "steam.game_servers"
    "steam.globalid"
    "steam.guard"
    "steam.monkey"
    "steam.steamid"
    "steam.webapi"
    "steam.webauth"
    "steam.utils"
  ];

  meta = with lib; {
    description = "Python package for interacting with Steam";
    homepage = "https://github.com/ValvePython/steam";
    changelog = "https://github.com/ValvePython/steam/blob/${src.rev}/CHANGES.md";
    license = licenses.mit;
    maintainers = with maintainers; [vinnymeller];
  };
}
