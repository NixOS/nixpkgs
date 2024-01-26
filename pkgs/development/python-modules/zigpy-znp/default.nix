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
, setuptools
, voluptuous
, zigpy
}:

buildPythonPackage rec {
  pname = "zigpy-znp";
  version = "0.12.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "zigpy";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-Bs/m9Iyr8x+sMUVXt1whk2E4EJ5bpitMsEWZtmCyIf8=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "timeout = 20" "timeout = 300" \
      --replace ', "setuptools-git-versioning<2"' "" \
      --replace 'dynamic = ["version"]' 'version = "${version}"'
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
