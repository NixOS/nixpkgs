{ lib
, buildPythonApplication
, appdirs
, beautifulsoup4
, colorlog
, fetchFromGitHub
, mako
, online-judge-api-client
, online-judge-tools
, ply
, pyyaml
, requests
, setuptools
, toml
}:

buildPythonApplication rec {
  pname = "online-judge-template-generator";
  version = "4.8.1";

  src = fetchFromGitHub {
    owner = "online-judge-tools";
    repo = "template-generator";
    rev = "v${version}";
    sha256 = "sha256-cS1ED1a92fEFqy6ht8UFjxocWIm35IA/VuaPSLsdlqg=";
  };

  propagatedBuildInputs = [
    appdirs
    beautifulsoup4
    colorlog
    mako
    online-judge-api-client
    online-judge-tools
    ply
    pyyaml
    requests
    setuptools
    toml
  ];

  # Needs internet to run tests
  doCheck = false;

  meta = with lib; {
    description = "Analyze problems of competitive programming and automatically generate boilerplate";
    homepage = "https://github.com/online-judge-tools/template-generator";
    license = licenses.mit;
    maintainers = with maintainers; [ sei40kr ];
  };
}
