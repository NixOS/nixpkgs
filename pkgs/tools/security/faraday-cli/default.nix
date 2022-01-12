{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "faraday-cli";
  version = "2.0.2";

  disabled = python3.pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "infobyte";
    repo = pname;
    rev = "v${version}";
    sha256 = "1jq8sim0b6k830lv1qzbrd1mx0nc2x1jq24fbama76gzqlb2axi7";
  };

  propagatedBuildInputs = with python3.pkgs; [
    click
    colorama
    faraday-plugins
    jsonschema
    pyyaml
    simple-rest-client
    tabulate
    validators
    spinners
    termcolor
    cmd2
    log-symbols
    arrow
  ];

  # Tests requires credentials
  doCheck = false;

  pythonImportsCheck = [ "faraday_cli" ];

  meta = with lib; {
    description = "Command Line Interface for Faraday";
    homepage = "https://github.com/infobyte/faraday-cli";
    license = with licenses; [ gpl3Only ];
    maintainers = with maintainers; [ fab ];
  };
}
