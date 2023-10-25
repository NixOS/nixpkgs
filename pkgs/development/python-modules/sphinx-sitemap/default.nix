{ lib
, buildPythonPackage
, fetchPypi
, sphinx
}:
let
  pname = "sphinx-sitemap";
  version = "2.5.1";
in
buildPythonPackage {
  inherit pname version;
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-mEvvBou9vCbPriCai2E5LpaBq8kZG0d80w2kBuOmDuU=";
  };

  propagatedBuildInputs = [
    sphinx
  ];

  # Latest tests do not pass on Sphinx5, although it is supported
  # Ref: https://github.com/jdillard/sphinx-sitemap/blob/ce244e9e1e05f09c566432f6a89bcd6f6ebe83bf/tox.ini#L18C25-L18C25
  doCheck = false;

  meta = with lib; {
    changelog = "https://github.com/jdillard/sphinx-sitemap/releases/tag/v${version}";
    description = "Sitemap generator for Sphinx";
    homepage = "https://github.com/jdillard/sphinx-sitemap";
    maintainers = with maintainers; [ alejandrosame ];
    license = licenses.mit;
  };
}
