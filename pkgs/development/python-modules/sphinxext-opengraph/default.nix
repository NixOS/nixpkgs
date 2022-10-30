{ lib
, buildPythonPackage
, fetchFromGitHub
, sphinx
, pytestCheckHook
, beautifulsoup4
}:

buildPythonPackage rec {
  pname = "sphinxext-opengraph";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "wpilibsuite";
    repo = "sphinxext-opengraph";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-7d75PocEjtVKCuUxpbRHKyS893g2RIFb7nj0pKs1Vow=";
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
