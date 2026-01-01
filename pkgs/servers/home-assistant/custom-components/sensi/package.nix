{
  lib,
  fetchFromGitHub,
  buildHomeAssistantComponent,
  websockets,
}:
buildHomeAssistantComponent rec {
  owner = "iprak";
  domain = "sensi";
<<<<<<< HEAD
  version = "1.4.8";
=======
  version = "1.4.3";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    inherit owner;
    repo = domain;
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-qNvob0fqgrUMem8pL2Jabo6xFH5ZIuv7/Tk0LT18qbk=";
=======
    hash = "sha256-rF+BAP3Du+4Xoct63VzyGhQh933b8QyNMWk6qFj4e5s=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  dependencies = [
    websockets
  ];

<<<<<<< HEAD
  meta = {
    changelog = "https://github.com/iprak/sensi/releases/tag/v${version}";
    description = "HomeAssistant integration for Sensi thermostat";
    homepage = "https://github.com/iprak/sensi";
    maintainers = with lib.maintainers; [ ivan ];
    license = lib.licenses.mit;
=======
  meta = with lib; {
    changelog = "https://github.com/iprak/sensi/releases/tag/v${version}";
    description = "HomeAssistant integration for Sensi thermostat";
    homepage = "https://github.com/iprak/sensi";
    maintainers = with maintainers; [ ivan ];
    license = licenses.mit;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
