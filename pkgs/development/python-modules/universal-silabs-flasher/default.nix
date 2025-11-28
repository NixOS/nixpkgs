{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,

  # build-system
  setuptools,

  # dependencies
  async-timeout,
  bellows,
  click,
  coloredlogs,
  crc,
  libgpiod,
  pyserial-asyncio-fast,
  typing-extensions,
  zigpy,

  # tests
  pytestCheckHook,
  pytest-asyncio,
  pytest-mock,
  pytest-timeout,
}:

buildPythonPackage rec {
  pname = "universal-silabs-flasher";
  version = "0.1.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "NabuCasa";
    repo = "universal-silabs-flasher";
    tag = "v${version}";
    hash = "sha256-Qeudh75PzIxI4vr3H4nBULhM2X8WSPF8hrT2uMWopHQ=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail '"setuptools-git-versioning>=2.0,<3"' "" \
      --replace-fail 'dynamic = ["version"]' 'version = "${version}"'
  '';

  build-system = [ setuptools ];

  dependencies = [
    bellows
    click
    coloredlogs
    crc
    pyserial-asyncio-fast
    typing-extensions
    zigpy
  ]
  ++ lib.optionals (pythonOlder "3.11") [ async-timeout ]
  ++ lib.optionals (stdenv.hostPlatform.isLinux) [ libgpiod ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
    pytest-mock
    pytest-timeout
  ];

  pythonImportsCheck = [ "universal_silabs_flasher" ];

  meta = with lib; {
    changelog = "https://github.com/NabuCasa/universal-silabs-flasher/releases/tag/${src.tag}";
    description = "Flashes Silicon Labs radios running EmberZNet or CPC multi-pan firmware";
    mainProgram = "universal-silabs-flasher";
    homepage = "https://github.com/NabuCasa/universal-silabs-flasher";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ hexa ];
  };
}
