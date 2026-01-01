{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  home-assistant,
  pytestCheckHook,
  pytest-cov-stub,
  pytest-homeassistant-custom-component,

  # dependency
  moonraker-api,
}:

buildHomeAssistantComponent rec {
  owner = "marcolivierarsenault";
  domain = "moonraker";
<<<<<<< HEAD
  version = "1.12.0";
=======
  version = "1.11.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "marcolivierarsenault";
    repo = "moonraker-home-assistant";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-T/7A5LmDmqaThTa1TnDbXwA0qeipIk750+k1Kt7tFeY=";
=======
    hash = "sha256-3qxTigKBZ7maUylx0NCf70tURNUWFpo2TzgxnxqjUpA=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  dependencies = [
    moonraker-api
  ];

  nativeCheckInputs = [
    pytest-homeassistant-custom-component
    pytest-cov-stub
    pytestCheckHook
  ]
  ++ home-assistant.getPackages "camera" home-assistant.python.pkgs;

  #skip phases with nothing to do
  dontConfigure = true;

<<<<<<< HEAD
  meta = {
    changelog = "https://github.com/marcolivierarsenault/moonraker-home-assistant/releases/tag/${version}";
    description = "Custom integration for Moonraker and Klipper in Home Assistant";
    homepage = "https://github.com/marcolivierarsenault/moonraker-home-assistant";
    maintainers = with lib.maintainers; [ _9R ];
    license = lib.licenses.mit;
=======
  meta = with lib; {
    changelog = "https://github.com/marcolivierarsenault/moonraker-home-assistant/releases/tag/${version}";
    description = "Custom integration for Moonraker and Klipper in Home Assistant";
    homepage = "https://github.com/marcolivierarsenault/moonraker-home-assistant";
    maintainers = with maintainers; [ _9R ];
    license = licenses.mit;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
