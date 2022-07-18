{ lib
, python3
}:

let
  python = python3.override {
    packageOverrides = self: super: {
      click = super.click.overrideAttrs (oldAttrs: rec {
        version = "8.0.4";
        src = oldAttrs.src.override {
          inherit version;
          sha256 = "sha256-hFjXsSh8X7EoyQ4jOBz5nc3nS+r2x/9jhM6E1v4JCts=";
        };
      });
    };
  };
in

python.pkgs.buildPythonApplication rec {
  pname = "homeassistant-cli";
  version = "0.9.4";

  src = python3.pkgs.fetchPypi {
    inherit pname version;
    sha256 = "03kiyqpp3zf8rg30d12h4fapihh0rqwpv5p8jfxb3iq0chfmjx2f";
  };

  postPatch = ''
    # Ignore pinned versions
    sed -i "s/'\(.*\)\(==\|>=\).*'/'\1'/g" setup.py
  '';

  propagatedBuildInputs = with python.pkgs; [
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

  # Completion needs to be ported to work with click > 8.0
  # https://github.com/home-assistant-ecosystem/home-assistant-cli/issues/367
  #postInstall = ''
  #  mkdir -p "$out/share/bash-completion/completions" "$out/share/zsh/site-functions"
  #  $out/bin/hass-cli completion bash > "$out/share/bash-completion/completions/hass-cli"
  #  $out/bin/hass-cli completion zsh > "$out/share/zsh/site-functions/_hass-cli"
  #'';

  checkInputs = with python.pkgs; [
    pytestCheckHook
    requests-mock
  ];

  meta = with lib; {
    description = "Command-line tool for Home Assistant";
    homepage = "https://github.com/home-assistant-ecosystem/home-assistant-cli";
    changelog = "https://github.com/home-assistant-ecosystem/home-assistant-cli/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = teams.home-assistant.members;
  };
}
