{
  buildHomeAssistantComponent,
  fetchFromGitHub,
  lib,

  # dependencies
  mypyllant,
  voluptuous,

  # tests
  aioresponses,
  polyfactory,
  pytest-cov-stub,
  pytest-homeassistant-custom-component,
  pytest-xdist,
  pytestCheckHook,
}:

buildHomeAssistantComponent rec {
  owner = "signalkraft";
  domain = "mypyllant";
  version = "0.9.12";

  src = fetchFromGitHub {
    owner = "signalkraft";
    repo = "mypyllant-component";
    tag = "v${version}";
    hash = "sha256-vXzcVua2cGQXXeug6Zy4AAeTok+BLH5k+krq3UBuQjw=";
  };

  dependencies = [
    mypyllant
    voluptuous
  ];

  nativeCheckInputs = [
    aioresponses
    polyfactory
    pytest-cov-stub
    pytest-homeassistant-custom-component
    pytest-xdist
    pytestCheckHook
  ];

  meta = {
    description = "Unofficial Home Assistant integration for interacting with myVAILLANT";
    changelog = "https://github.com/signalkraft/mypyllant-component/releases/tag/${src.tag}";
    homepage = "https://github.com/signalkraft/mypyllant-component";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ urbas ];
  };
}
