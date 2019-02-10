# dateparser tests fail on pyton37: https://github.com/NixOS/nixpkgs/issues/52766
{ lib, python36, glibcLocales }:

python36.pkgs.buildPythonApplication rec {
  pname = "homeassistant-cli";
  version = "0.5.0";

  src = python36.pkgs.fetchPypi {
    inherit pname version;
    sha256 = "4ad137d336508ab74840a34b3cc488ad884cc75285f5d7842544df1c3adacf8d";
  };

  postPatch = ''
    # Ignore pinned versions
    sed -i "s/'\(.*\)\(==\|>=\).*'/'\1'/g" setup.py
  '';

  nativeBuildInputs = [
    glibcLocales
  ];

  propagatedBuildInputs = with python36.pkgs; [
    requests netdisco click click-log tabulate jsonpath_rw jinja2 dateparser regex ruamel_yaml aiohttp
  ];

  LC_ALL = "en_US.UTF-8";

  postInstall = ''
    mkdir -p "$out/share/bash-completion/completions" "$out/share/zsh/site-functions"
    $out/bin/hass-cli completion bash > "$out/share/bash-completion/completions/hass-cli"
    $out/bin/hass-cli completion zsh > "$out/share/zsh/site-functions/_hass-cli"
  '';

  checkInputs = with python36.pkgs; [
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
