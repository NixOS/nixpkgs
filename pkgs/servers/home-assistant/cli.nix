{ lib, python3, glibcLocales }:

python3.pkgs.buildPythonApplication rec {
  pname = "homeassistant-cli";
  version = "0.6.0";

  src = python3.pkgs.fetchPypi {
    inherit pname version;
    sha256 = "0yjqjfqr1gc4c9k5z5i7ngcpcwmyp3lzs4xv7allgqvglmw26ji4";
  };

  postPatch = ''
    # Ignore pinned versions
    sed -i "s/'\(.*\)\(==\|>=\).*'/'\1'/g" setup.py
  '';

  nativeBuildInputs = [
    glibcLocales
  ];

  propagatedBuildInputs = with python3.pkgs; [
    requests netdisco click click-log tabulate jsonpath_rw jinja2 dateparser regex ruamel_yaml aiohttp
  ];

  LC_ALL = "en_US.UTF-8";

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
    description = "Command-line tool for Home Asssistant";
    homepage = https://github.com/home-assistant/home-assistant-cli;
    license = licenses.asl20;
    maintainers = with maintainers; [ dotlambda ];
  };
}
