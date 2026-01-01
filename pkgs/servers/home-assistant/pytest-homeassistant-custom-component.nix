{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  setuptools,
  aiohttp,
  bcrypt,
  freezegun,
  homeassistant,
  pytest-asyncio,
  pytest-socket,
  requests-mock,
  respx,
  syrupy,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pytest-homeassistant-custom-component";
<<<<<<< HEAD
  version = "0.13.301";
=======
  version = "0.13.285";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  disabled = pythonOlder "3.13";

  src = fetchFromGitHub {
    owner = "MatthewFlamm";
    repo = "pytest-homeassistant-custom-component";
<<<<<<< HEAD
    tag = version;
    hash = "sha256-ayLMdWz2KrHkAUc46QdjsikdO96YtpaPeDNGEfkYo9w=";
=======
    rev = "refs/tags/${version}";
    hash = "sha256-pP8zUjOhhaXE+cbx3fKlJaoNBBprOfAKS0F92Tf8hjI=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [ setuptools ];

  pythonRemoveDeps = true;

  dependencies = [
    aiohttp
    bcrypt
    freezegun
    homeassistant
    pytest-asyncio
    pytest-socket
    requests-mock
    respx
    syrupy
  ];

  pythonImportsCheck = [ "pytest_homeassistant_custom_component.plugins" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
<<<<<<< HEAD
    changelog = "https://github.com/MatthewFlamm/pytest-homeassistant-custom-component/blob/${src.tag}/CHANGELOG.md";
=======
    changelog = "https://github.com/MatthewFlamm/pytest-homeassistant-custom-component/blob/${src.rev}/CHANGELOG.md";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "Package to automatically extract testing plugins from Home Assistant for custom component testing";
    homepage = "https://github.com/MatthewFlamm/pytest-homeassistant-custom-component";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
