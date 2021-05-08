{ lib
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "homeassistant-cli";
  version = "0.9.3";

  src = python3.pkgs.fetchPypi {
    inherit pname version;
    sha256 = "18h6bc99skzb0a1pffb6lr2z04928srrcz1w2zy66bndasic5yfs";
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

  postInstall = ''
    mkdir -p "$out/share/bash-completion/completions" "$out/share/zsh/site-functions"
    $out/bin/hass-cli completion bash > "$out/share/bash-completion/completions/hass-cli"
    $out/bin/hass-cli completion zsh > "$out/share/zsh/site-functions/_hass-cli"
  '';

  checkInputs = with python3.pkgs; [
    pytestCheckHook
    requests-mock
  ];

  meta = with lib; {
    description = "Command-line tool for Home Assistant";
    homepage = "https://github.com/home-assistant/home-assistant-cli";
    changelog = "https://github.com/home-assistant-ecosystem/home-assistant-cli/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = teams.home-assistant.members;
  };
}
