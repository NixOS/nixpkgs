{
  lib,
  stdenv,
  fetchFromGitHub,
  python3,
  installShellFiles,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "homeassistant-cli";
  version = "1.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "home-assistant-ecosystem";
    repo = "home-assistant-cli";
    tag = finalAttrs.version;
    hash = "sha256-LF6JXELAP3Mvta3RuDUs4UiQ7ptNFh0vZmPh3ICJFRY=";
  };

  pythonRelaxDeps = true;

  build-system = with python3.pkgs; [ poetry-core ];

  dependencies = with python3.pkgs; [
    aiohttp
    click
    click-log
    dateparser
    jinja2
    jsonpath-ng
    netdisco
    regex
    requests
    ruamel-yaml
    tabulate
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd hass-cli \
      --bash <(_HASS_CLI_COMPLETE=bash_source $out/bin/hass-cli) \
      --fish <(_HASS_CLI_COMPLETE=fish_source $out/bin/hass-cli) \
      --zsh <(_HASS_CLI_COMPLETE=zsh_source $out/bin/hass-cli)
  '';

  nativeBuildInputs = [ installShellFiles ];

  nativeCheckInputs = with python3.pkgs; [
    pytestCheckHook
    requests-mock
  ];

  pythonImportsCheck = [ "homeassistant_cli" ];

  meta = {
    description = "Command-line tool for Home Assistant";
    mainProgram = "hass-cli";
    homepage = "https://github.com/home-assistant-ecosystem/home-assistant-cli";
    changelog = "https://github.com/home-assistant-ecosystem/home-assistant-cli/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    teams = [ lib.teams.home-assistant ];
  };
})
