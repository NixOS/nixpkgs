{
  lib,
  buildPythonApplication,
  click,
  fetchFromGitHub,
  ipy,
  pyyaml,
  requests,
}:

buildPythonApplication rec {
  pname = "gandi-cli";
  version = "1.6";

  src = fetchFromGitHub {
    owner = "Gandi";
    repo = "gandi.cli";
    rev = version;
    sha256 = "sha256-KLeEbbzgqpmBjeTc5RYsFScym8xtMqVjU+H0lyDM0+o=";
  };

  propagatedBuildInputs = [
    click
    ipy
    pyyaml
    requests
  ];

  # Tests try to contact the actual remote API
  doCheck = false;
  pythonImportsCheck = [ "gandi" ];

  meta = with lib; {
    description = "Command-line interface to the public Gandi.net API";
    mainProgram = "gandi";
    homepage = "https://cli.gandi.net/";
    license = licenses.gpl3Plus;
    maintainers = [ ];
  };
}
