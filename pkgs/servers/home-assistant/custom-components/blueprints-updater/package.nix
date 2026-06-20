{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  httpx,
  home-assistant,
  pytest-cov-stub,
  pytest-homeassistant-custom-component,
  pytest-asyncio,
  pytestCheckHook,
}:

buildHomeAssistantComponent rec {
  owner = "luuquangvu";
  domain = "blueprints_updater";
  version = "2.8.1";

  src = fetchFromGitHub {
    inherit owner;
    repo = "blueprints-updater";
    tag = version;
    hash = "sha256-aqufiwH9yJmyr5Bd3Etwf5aK9dAfa7srXpBcmXDFAoY=";
  };

  patches = [
    # Do not skip blueprints symlinked from the nix store.
    # They cannot be updated, but users probably still want to be notified if they have an update.
    ./allow-symlinked-blueprints.diff
  ];

  postPatch = ''
    # avoid dependency on rather big pytest-timeout
    substituteInPlace pyproject.toml \
      --replace-fail '"--timeout=60",' ""
  '';

  dependencies = httpx.optional-dependencies.http2;

  nativeCheckInputs = [
    home-assistant
    pytest-asyncio
    pytest-cov-stub
    pytest-homeassistant-custom-component
    pytestCheckHook
  ];

  disabledTestPaths = [
    # pytest-homeassistant-custom-component tries to create temporary directories inside the nix store
    "tests/integration/test_init.py::test_full_update_lifecycle"
    "tests/integration/test_services.py::test_restore_blueprint_service"
    "tests/integration/test_services.py::test_update_all_service"
  ];

  meta = {
    description = "Automatically update Home Assistant blueprints via native update entities";
    homepage = "https://github.com/luuquangvu/blueprints-updater/";
    changelog = "https://github.com/luuquangvu/blueprints-updater/releases/tag/${src.tag}";
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
    license = lib.licenses.mit;
  };
}
