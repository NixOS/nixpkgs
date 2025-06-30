{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  sphinx,
}:

buildPythonPackage rec {
  pname = "sphinx-jinja";
  version = "2.0.2";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-xiMrWaiUE5dwvh3G0LAKN55CiM54FXkE4fhHPeo+Bxg=";
  };

  propagatedBuildInputs = [ sphinx ];

  # upstream source is not updated to 2.0.X and pypi does not contain tests
  doCheck = false;

  pythonImportsCheck = [ "sphinx_jinja" ];

  meta = with lib; {
    description = "Sphinx extension to include jinja templates in documentation";
    homepage = "https://github.com/tardyp/sphinx-jinja";
    maintainers = [ ];
    license = licenses.mit;
  };
}
