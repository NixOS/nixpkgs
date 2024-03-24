{ lib
, buildPythonPackage
, click
, fetchFromGitHub
, requests
, urllib3
, setuptools
}:
buildPythonPackage rec {
  pname = "waybackpy";
  version = "3.0.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "akamhy";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-0rD/QKBC/gvPfrXxHSr0lwxNPAhnKyFHHarutzOC7uo=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    click
    requests
    urllib3
  ];

  # Lots of tests depend on internet connectivity
  doCheck = false;

  pythonImportsCheck = [
    "waybackpy"
  ];

  meta = with lib; {
    description = "Python package & CLI tool that interfaces the Wayback Machine APIs";
    homepage = "https://akamhy.github.io/waybackpy/";
    license = licenses.mit;
    maintainers = with maintainers; [ rogryza ];
  };
}

