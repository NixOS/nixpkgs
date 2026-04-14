{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  bellows,
  click,
  coloredlogs,
  crc,
  gpiod,
  pyserial-asyncio-fast,
  tqdm,
  typing-extensions,
  zigpy,

  # tests
  aioresponses,
  pytestCheckHook,
  pytest-asyncio,
}:

buildPythonPackage rec {
  pname = "universal-silabs-flasher";
  version = "1.0.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "NabuCasa";
    repo = "universal-silabs-flasher";
    tag = "v${version}";
    hash = "sha256-6rdWi+un85YWSann2zHFFnWvAZF6V8wXBP1VunaiZMo=";
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
    tqdm
    typing-extensions
    zigpy
  ]
  ++ lib.optionals (stdenv.hostPlatform.isLinux) [ gpiod ];

  nativeCheckInputs = [
    aioresponses
    pytestCheckHook
    pytest-asyncio
  ];

  disabledTests = [
    # timing sensitive
    "test_xmodem_happy_path"
  ];

  pythonImportsCheck = [ "universal_silabs_flasher" ];

  meta = {
    changelog = "https://github.com/NabuCasa/universal-silabs-flasher/releases/tag/${src.tag}";
    description = "Flashes Silicon Labs radios running EmberZNet or CPC multi-pan firmware";
    mainProgram = "universal-silabs-flasher";
    homepage = "https://github.com/NabuCasa/universal-silabs-flasher";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ hexa ];
  };
}
