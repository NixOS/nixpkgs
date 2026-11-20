{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  aiohttp,
  bellows,
  coloredlogs,
  crc,
  gpiod,
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
  version = "1.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "NabuCasa";
    repo = "universal-silabs-flasher";
    tag = "v${version}";
    hash = "sha256-niNjHhOwy+5mgs4UY9bIBykmZ+7TifbYnMuG1LAV7PA=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail '"setuptools-git-versioning>=2.0,<3"' "" \
      --replace-fail 'dynamic = ["version"]' 'version = "${version}"'
  '';

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    bellows
    coloredlogs
    crc
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
