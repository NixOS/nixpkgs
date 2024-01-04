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
  version = "0.0.16";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "NabuCasa";
    repo = "universal-silabs-flasher";
    rev = "refs/tags/v${version}";
    hash = "sha256-2R5W24B2Bb6WwIbBE4hWG/bPsWuKchE4XbEh8OpiSu4=";
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
