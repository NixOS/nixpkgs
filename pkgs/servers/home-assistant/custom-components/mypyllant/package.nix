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
  pytest-cov,
  pytest-homeassistant-custom-component,
  pytest-xdist,
  pytestCheckHook,
}:

buildHomeAssistantComponent rec {
  owner = "signalkraft";
  domain = "mypyllant";
  version = "0.9.9";

  src = fetchFromGitHub {
    owner = "signalkraft";
    repo = "mypyllant-component";
    tag = "v${version}";
    hash = "sha256-6T8SGAP2535VqZmvSeITpMIa0SBJhnWsOKM1Y66WhHE=";
  };

  nativeCheckInputs = [
    aioresponses
    polyfactory
    pytest-cov
    pytest-homeassistant-custom-component
    pytest-xdist
    pytestCheckHook
  ];

  dependencies = [
    mypyllant
    voluptuous
  ];

  meta = with lib; {
    description = "Unofficial Home Assistant integration for interacting with myVAILLANT";
    changelog = "https://github.com/signalkraft/mypyllant-component/releases/tag/${src.tag}";
    homepage = "https://github.com/signalkraft/mypyllant-component";
    license = licenses.mit;
    maintainers = with maintainers; [ urbas ];
  };
}
