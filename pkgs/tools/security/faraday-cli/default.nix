{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "faraday-cli";
  version = "2.1.6";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "infobyte";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-ofL3tRYV2bwF+RYGoLpg/UQPg9HwrCepWAQxXiJkV2E=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    arrow
    click
    cmd2
    colorama
    faraday-plugins
    jsonschema
    log-symbols
    luddite
    packaging
    pyyaml
    py-sneakers
    simple-rest-client
    spinners
    tabulate
    termcolor
    validators
  ];

  # Tests requires credentials
  doCheck = false;

  pythonImportsCheck = [
    "faraday_cli"
  ];

  meta = with lib; {
    description = "Command Line Interface for Faraday";
    homepage = "https://github.com/infobyte/faraday-cli";
    license = with licenses; [ gpl3Only ];
    maintainers = with maintainers; [ fab ];
  };
}
