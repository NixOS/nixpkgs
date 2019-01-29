# dateparser tests fail on pyton37: https://github.com/NixOS/nixpkgs/issues/52766
{ lib, python36, glibcLocales }:

python36.pkgs.buildPythonApplication rec {
  pname = "homeassistant-cli";
  version = "0.4.2";

  src = python36.pkgs.fetchPypi {
    inherit pname version;
    sha256 = "e0b05af9e49baf88a44f1b36c3446a106223016dceefd5f9910e204af5901f44";
  };

  postPatch = ''
    # Ignore pinned versions
    sed -i "s/'\(.*\)\(==\|>=\).*'/'\1'/g" setup.py
  '';

  propagatedBuildInputs = with python36.pkgs; [
    requests pyyaml netdisco click click-log tabulate idna jsonpath_rw jinja2 dateparser
  ];

  checkInputs = with python36.pkgs; [
    pytest requests-mock glibcLocales
  ];

  checkPhase = ''
    LC_ALL=en_US.UTF-8 pytest
  '';

  meta = with lib; {
    description = "Command-line tool for Home Asssistant";
    homepage = https://github.com/home-assistant/home-assistant-cli;
    license = licenses.asl20;
    maintainers = with maintainers; [ dotlambda ];
  };
}
