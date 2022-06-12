{ lib, buildPythonPackage, fetchPypi, pythonOlder, sphinx }:

buildPythonPackage rec {
  pname = "sphinx-jinja";
  version = "2.0.1";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-3lMY1InG1PaAqhIrp5kovE6t+kTTpTKS3ir+WI/+RAY=";
  };

  propagatedBuildInputs = [ sphinx ];

  # upstream source is not updated to 2.0.X and pypi does not contain tests
  doCheck = false;

  pythonImportsCheck = [ "sphinx_jinja" ];

  meta = with lib; {
    description = "Sphinx extension to include jinja templates in documentation";
    homepage = "https://github.com/tardyp/sphinx-jinja";
    maintainers = with maintainers; [ ];
    license = licenses.mit;
  };
}
