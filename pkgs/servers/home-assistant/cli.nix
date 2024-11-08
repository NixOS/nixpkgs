{
  lib,
  stdenv,
  fetchFromGitHub,
  python3,
  installShellFiles,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "homeassistant-cli";
  version = "0.9.6";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "home-assistant-ecosystem";
    repo = "home-assistant-cli";
    rev = version;
    hash = "sha256-4OeHJ7icDZUOC5K4L0F0Nd9lbJPgdW4LCU0wniLvJ1Q=";
  };

  postPatch = ''
    # Ignore pinned versions
    sed -i "s/'\(.*\)\(==\|>=\).*'/'\1'/g" setup.py
  '';

  propagatedBuildInputs = with python3.pkgs; [
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
    changelog = "https://github.com/home-assistant-ecosystem/home-assistant-cli/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = lib.teams.home-assistant.members;
  };
}
