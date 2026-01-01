{
  lib,
  fetchFromGitHub,
  buildHomeAssistantComponent,

  # dependencies
  aiomqtt,
  colorlog,
  loguru,
  websocket-client,
  websockets,

  # tests
  pytestCheckHook,
  aiohttp,
  home-assistant,
}:

buildHomeAssistantComponent rec {
  owner = "danielcherubini";
  domain = "elegoo_printer";
<<<<<<< HEAD
  version = "2.5.0";
=======
  version = "2.4.4";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "danielcherubini";
    repo = "elegoo-homeassistant";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-zxFiT6vlaC+cxLKZz4rtdA6Cg41K+07KY5rsOyNxnWI=";
=======
    hash = "sha256-zjVii3ipkjSiF6ELujH+JSRSyIWfpeNFFzdQKasUsfo=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  dependencies = [
    aiomqtt
    colorlog
    loguru
    websocket-client
    websockets
  ];

  nativeCheckInputs = [
    pytestCheckHook
    aiohttp
    home-assistant
  ];

<<<<<<< HEAD
  meta = {
    changelog = "https://github.com/danielcherubini/elegoo-homeassistant/releases/tag/v${version}";
    description = "Home Assistant integration for Elegoo 3D printers using the SDCP protocol";
    homepage = "https://github.com/danielcherubini/elegoo-homeassistant";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
=======
  meta = with lib; {
    changelog = "https://github.com/danielcherubini/elegoo-homeassistant/releases/tag/v${version}";
    description = "Home Assistant integration for Elegoo 3D printers using the SDCP protocol";
    homepage = "https://github.com/danielcherubini/elegoo-homeassistant";
    license = licenses.mit;
    maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      typedrat
    ];
  };
}
