{ lib
, buildPythonPackage
, fetchPypi
, sphinx
, pytest
,
}:
let
  pname = "sphinx-sitemap";
  version = "2.5.1";
in
buildPythonPackage {
  inherit pname version;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-mEvvBou9vCbPriCai2E5LpaBq8kZG0d80w2kBuOmDuU=";
  };

  propagatedBuildInputs = [
    sphinx
  ];

  nativeCheckInputs = [
    pytest
  ];

  doCheck = true;
  checkPhase = ''
    pytest --fixtures tests
  '';

  meta = with lib; {
    changelog = "https://github.com/jdillard/sphinx-sitemap/releases/tag/v${version}";
    description = "Sitemap generator for Sphinx";
    homepage = "https://github.com/jdillard/sphinx-sitemap";
    maintainers = with maintainers; [ alejandrosame ];
    license = licenses.mit;
  };
}
