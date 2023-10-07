{ buildPythonPackage
, django
, fetchFromGitHub
, lib
, python
}:

buildPythonPackage rec {
  pname = "telepath";
  version = "0.3";

  src = fetchFromGitHub {
    repo = "telepath";
    owner = "wagtail";
    rev = "v${version}";
    sha256 = "sha256-kfEAYCXbK0HTf1Gut/APkpw2krMa6C6mU/dJ0dsqzS0=";
  };

  checkInputs = [ django ];

  checkPhase = ''
    ${python.interpreter} -m django test --settings=telepath.test_settings
  '';

  pythonImportsCheck = [ "telepath" ];

  meta = with lib; {
    description = "A library for exchanging data between Python and JavaScript";
    homepage = "https://github.com/wagtail/telepath";
    changelog = "https://github.com/wagtail/telepath/blob/v${version}/CHANGELOG.md";
    license = licenses.bsd3;
    maintainers = with maintainers; [ sephi ];
  };
}
