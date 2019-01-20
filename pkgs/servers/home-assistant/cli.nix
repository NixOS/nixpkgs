{ lib, python3 }:

python3.pkgs.buildPythonApplication rec {
  pname = "homeassistant-cli";
  version = "0.3.0";

  src = python3.pkgs.fetchPypi {
    inherit pname version;
    sha256 = "42d7cb008801d7a448b62aed1fc46dd450ee67397bf16faabb02f691417db4b2";
  };

  postPatch = ''
    # Ignore pinned versions
    sed -i "s/'\(.*\)==.*'/'\1'/g" setup.py
  '';

  propagatedBuildInputs = with python3.pkgs; [
    requests pyyaml netdisco click click-log tabulate idna jsonpath_rw jinja2
  ];

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
