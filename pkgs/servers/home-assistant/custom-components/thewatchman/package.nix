{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  prettytable,
  pytest-cov-stub,
  pytest-homeassistant-custom-component,
  pytestCheckHook,
}:

buildHomeAssistantComponent rec {
  owner = "dummylabs";
  domain = "watchman";
  version = "0.7.0-beta.1";

  src = fetchFromGitHub {
    owner = "dummylabs";
    repo = "thewatchman";
    tag = "v${version}";
    hash = "sha256-U2AYxQ37XQocHcnY2Uv9Lhu0LmEZhhcGdO29i565tBM=";
  };

  postPatch = ''
    substituteInPlace custom_components/watchman/manifest.json \
      --replace-fail "prettytable==3.12.0" "prettytable"

    substituteInPlace tests/{__init__,test_{action,regex,report}}.py \
      --replace-fail "/workspaces/thewatchman/" ""
  '';

  dontBuild = true;

  dependencies = [
    prettytable
  ];

  nativeCheckInputs = [
    pytest-cov-stub
    pytest-homeassistant-custom-component
    pytestCheckHook
  ];

  meta = {
    description = "Keep track of missing entities and services in your config files";
    homepage = "https://github.com/dummylabs/thewatchman";
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
    license = lib.licenses.mit;
  };
}
