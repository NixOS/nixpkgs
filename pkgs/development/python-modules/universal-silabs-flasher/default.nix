{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub

# build-system
, setuptools
, setuptools-git-versioning

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
  version = "0.0.15";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "NabuCasa";
    repo = "universal-silabs-flasher";
    rev = "v${version}";
    hash = "sha256-5hA1i2XzKzQDRrZfOaA6I3X7hU+nSd7HpcHHNIzZO7g=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-git-versioning
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
    changelog = "https://github.com/NabuCasa/universal-silabs-flasher/releases/tag/v${version}";
    description = "Flashes Silicon Labs radios running EmberZNet or CPC multi-pan firmware";
    homepage = "https://github.com/NabuCasa/universal-silabs-flasher";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ hexa ];
  };
}
