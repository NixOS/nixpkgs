# dateparser tests fail on pyton37: https://github.com/NixOS/nixpkgs/issues/52766
{ lib, python36, glibcLocales }:

python36.pkgs.buildPythonApplication rec {
  pname = "homeassistant-cli";
  version = "0.4.4";

  src = python36.pkgs.fetchPypi {
    inherit pname version;
    sha256 = "ad3722062ffb7b4fa730f61991b831dbf083e4e079c560993a023ce4bb11c55d";
  };

  postPatch = ''
    # Ignore pinned versions
    sed -i "s/'\(.*\)\(==\|>=\).*'/'\1'/g" setup.py
  '';

  nativeBuildInputs = [
    glibcLocales
  ];

  propagatedBuildInputs = with python36.pkgs; [
    requests pyyaml netdisco click click-log tabulate idna jsonpath_rw jinja2 dateparser
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
