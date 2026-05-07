{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  fetchNpmDeps,
  aiofiles,
  jinja2,
  joserfc,
  nodejs,
  npmHooks,
  pytestCheckHook,
  pytest-homeassistant-custom-component,
  pytest-cov-stub,
}:

buildHomeAssistantComponent rec {
  owner = "christaangoossens";
  domain = "auth_oidc";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "christiaangoossens";
    repo = "hass-oidc-auth";
    tag = "v${version}";
    hash = "sha256-ZYJD0PVh2E07cdY1a7uxSxdooAMz78HwJpwr4uWofZM=";
  };

  postPatch = ''
    # Tests import directly from auth_oidc, but the component is installed
    # under custom_components.auth_oidc
    for f in tests/test_hass_webserver.py tests/test_state_store.py; do
      substituteInPlace "$f" \
        --replace-fail "from auth_oidc" "from custom_components.auth_oidc"
    done
  '';

  env.npmDeps = fetchNpmDeps {
    name = "${domain}-npm-deps";
    inherit src;
    hash = "sha256-R5i4o2VnaXwgX72r6cBJULxSKadkU22vriMMWoMc5As=";
  };

  nativeBuildInputs = [
    npmHooks.npmConfigHook
    nodejs
  ];

  dependencies = [
    aiofiles
    jinja2
    joserfc
  ];

  postBuild = ''
    npm run css
  '';

  nativeCheckInputs = [
    pytestCheckHook
    pytest-homeassistant-custom-component
    pytest-cov-stub
  ];

  meta = {
    changelog = "https://github.com/christiaangoossens/hass-oidc-auth/releases/tag/v${version}";
    description = "OpenID Connect authentication provider for Home Assistant";
    homepage = "https://github.com/christiaangoossens/hass-oidc-auth";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hexa ];
  };
}
