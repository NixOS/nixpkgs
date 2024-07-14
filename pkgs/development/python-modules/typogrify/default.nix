{
  lib,
  buildPythonPackage,
  fetchPypi,
  smartypants,
}:

buildPythonPackage rec {
  pname = "typogrify";
  version = "2.0.7";

  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-i+RmjNpDQWPOIp2Hyic6EZIssWFMs1mXC33Jbu0Tyzg=";
  };

  propagatedBuildInputs = [ smartypants ];

  # Wants to set up Django
  doCheck = false;

  pythonImportsCheck = [ "typogrify.filters" ];

  meta = with lib; {
    description = "Filters to enhance web typography, including support for Django & Jinja templates";
    homepage = "https://github.com/mintchaos/typogrify";
    license = licenses.bsd3;
    maintainers = with maintainers; [ dotlambda ];
  };
}
