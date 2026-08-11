{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  home-assistant,
  httpx,
  pytest-asyncio,
  pytest-cov-stub,
  pytest-homeassistant-custom-component,
  pytest-xdist,
  pytestCheckHook,
}:

buildHomeAssistantComponent rec {
  owner = "luuquangvu";
  domain = "blueprints_updater";
  version = "2.11.1";

  src = fetchFromGitHub {
    inherit owner;
    repo = "blueprints-updater";
    tag = version;
    hash = "sha256-hFBOmjbhw8HECJLj/MmgCzCb1rVlh7k/oI9v20HuYlI=";
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
    pytest-xdist
    pytestCheckHook
  ];

  meta = {
    description = "Automatically update Home Assistant blueprints via native update entities";
    homepage = "https://github.com/luuquangvu/blueprints-updater/";
    changelog = "https://github.com/luuquangvu/blueprints-updater/releases/tag/${src.tag}";
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
    license = lib.licenses.mit;
  };
}
