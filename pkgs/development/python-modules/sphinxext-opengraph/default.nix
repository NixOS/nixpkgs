{ lib
, buildPythonPackage
, fetchFromGitHub
, sphinx
, pytestCheckHook
, beautifulsoup4
}:

buildPythonPackage rec {
  pname = "sphinxext-opengraph";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "wpilibsuite";
    repo = "sphinxext-opengraph";
    rev = "v${version}";
    sha256 = "sha256-US0UXxcTlN7x5v2ilpL+umTr7tadqthqhvfaQnm7tCc=";
  };

  propagatedBuildInputs = [
    sphinx
  ];

  checkInputs = [
    pytestCheckHook
    beautifulsoup4
  ];

  pythonImportsCheck = [ "sphinxext.opengraph" ];

  meta = with lib; {
    description = "Sphinx extension to generate unique OpenGraph metadata";
    homepage = "https://github.com/wpilibsuite/sphinxext-opengraph";
    license = licenses.mit;
    maintainers = with maintainers; [ Luflosi ];
  };
}
