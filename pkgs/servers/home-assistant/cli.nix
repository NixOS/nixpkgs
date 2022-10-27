{ lib
, fetchFromGitHub
, python3
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

  # TODO: Completion needs to be adapted after support for latest click was added
  # $ source <(_HASS_CLI_COMPLETE=bash_source hass-cli) # for bash
  # $ source <(_HASS_CLI_COMPLETE=zsh_source hass-cli)  # for zsh
  # $ eval (_HASS_CLI_COMPLETE=fish_source hass-cli)    # for fish
  #postInstall = ''
  #  mkdir -p "$out/share/bash-completion/completions" "$out/share/zsh/site-functions"
  #  $out/bin/hass-cli completion bash > "$out/share/bash-completion/completions/hass-cli"
  #  $out/bin/hass-cli completion zsh > "$out/share/zsh/site-functions/_hass-cli"
  #'';

  checkInputs = with python3.pkgs; [
    pytestCheckHook
    requests-mock
  ];

  pythonImportsCheck = [
    "homeassistant_cli"
  ];

  meta = with lib; {
    description = "Command-line tool for Home Assistant";
    homepage = "https://github.com/home-assistant-ecosystem/home-assistant-cli";
    changelog = "https://github.com/home-assistant-ecosystem/home-assistant-cli/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = teams.home-assistant.members;
  };
}
