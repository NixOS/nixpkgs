{ lib
, buildPythonPackage
, fetchFromGitHub
, sphinx
}:

buildPythonPackage rec {
  pname = "sphinxext-opengraph";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "wpilibsuite";
    repo = "sphinxext-opengraph";
    rev = "v${version}";
    sha256 = "sha256-978aPtaqUDHcswDdFynzi+IjDYaBmCZDZk+dmDkhajY=";
  };

  propagatedBuildInputs = [
    sphinx
  ];

  doCheck = false; # no tests

  pythonImportsCheck = [ "sphinxext.opengraph" ];

  meta = with lib; {
    description = "Sphinx extension to generate unique OpenGraph metadata";
    homepage = "https://github.com/wpilibsuite/sphinxext-opengraph";
    license = licenses.mit;
    maintainers = with maintainers; [ Luflosi ];
  };
}
