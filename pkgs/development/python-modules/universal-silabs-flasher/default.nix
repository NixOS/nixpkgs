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
  version = "0.0.14";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "NabuCasa";
    repo = "universal-silabs-flasher";
    rev = "v${version}";
    hash = "sha256-0c9b571gJXFOAe5ct8O/qy7D6rDosmBHDYEv6odLQ2s=";
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
