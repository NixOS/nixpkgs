{ lib
, async-timeout
, buildPythonPackage
, coloredlogs
, fetchFromGitHub
, jsonschema
, pytest-asyncio
, pytest-mock
, pytest-rerunfailures
, pytest-timeout
, pytestCheckHook
, pythonOlder
, voluptuous
, zigpy
}:

buildPythonPackage rec {
  pname = "zigpy-znp";
  version = "0.11.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "zigpy";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-gYzk3XHXlF4+lnrRHYS5RB2QD0oDHgnMov9UFmXder8=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "timeout = 20" "timeout = 300"
  '';

  propagatedBuildInputs = [
    async-timeout
    coloredlogs
    jsonschema
    voluptuous
    zigpy
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-mock
    pytest-rerunfailures
    pytest-timeout
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "--reruns=3"
  ];

  pythonImportsCheck = [
    "zigpy_znp"
  ];

  meta = with lib; {
    description = "Library for zigpy which communicates with TI ZNP radios";
    homepage = "https://github.com/zigpy/zigpy-znp";
    changelog = "https://github.com/zigpy/zigpy-znp/releases/tag/v${version}";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ mvnetbiz ];
    platforms = platforms.linux;
  };
}
