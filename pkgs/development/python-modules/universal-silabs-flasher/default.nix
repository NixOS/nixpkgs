{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub

# build-system
, setuptools
, setuptools-git-versioning
, wheel

# dependencies
, async-timeout
, bellows
, click
, coloredlogs
, crc
, libgpiod
, typing-extensions
, zigpy

# tests
, pytestCheckHook
, pytest-asyncio
, pytest-mock
, pytest-timeout
}:

buildPythonPackage rec {
  pname = "universal-silabs-flasher";
  version = "0.0.13";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "NabuCasa";
    repo = "universal-silabs-flasher";
    rev = "v${version}";
    hash = "sha256-qiaDPCnVb6JQ2fZRFK+QF4o8K2UbIWGNKl5oo6MQUW0=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-git-versioning
    wheel
  ];

  propagatedBuildInputs = [
    async-timeout
    bellows
    click
    coloredlogs
    crc
    typing-extensions
    zigpy
  ] ++ lib.optionals (stdenv.hostPlatform.isLinux) [
    libgpiod
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
    pytest-mock
    pytest-timeout
  ];

  pythonImportsCheck = [ "universal_silabs_flasher" ];

  meta = with lib; {
    description = "Flashes Silicon Labs radios running EmberZNet or CPC multi-pan firmware";
    homepage = "https://github.com/NabuCasa/universal-silabs-flasher";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ hexa ];
  };
}
