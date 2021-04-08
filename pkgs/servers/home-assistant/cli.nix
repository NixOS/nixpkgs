{ lib, python3 }:

python3.pkgs.buildPythonApplication rec {
  pname = "homeassistant-cli";
  version = "0.9.1";

  src = python3.pkgs.fetchPypi {
    inherit pname version;
    sha256 = "1a31ky2p5w8byf0bjgma6xi328jj690qqksm3dwbi3v8dpqvghgf";
  };

  postPatch = ''
    # Ignore pinned versions
    sed -i "s/'\(.*\)\(==\|>=\).*'/'\1'/g" setup.py
  '';

  propagatedBuildInputs = with python3.pkgs; [
    requests netdisco click click-log tabulate jsonpath_rw jinja2 dateparser regex ruamel_yaml aiohttp
  ];

  postInstall = ''
    mkdir -p "$out/share/bash-completion/completions" "$out/share/zsh/site-functions"
    $out/bin/hass-cli completion bash > "$out/share/bash-completion/completions/hass-cli"
    $out/bin/hass-cli completion zsh > "$out/share/zsh/site-functions/_hass-cli"
  '';

  checkInputs = with python3.pkgs; [
    pytest requests-mock
  ];

  checkPhase = ''
    pytest
  '';

  meta = with lib; {
    description = "Command-line tool for Home Assistant";
    homepage = "https://github.com/home-assistant/home-assistant-cli";
    license = licenses.asl20;
    maintainers = teams.home-assistant.members;
  };
}
