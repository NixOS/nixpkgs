{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "simplekml";
  version = "1.3.6";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-zaaHvidUOV/KtmTpCOv1ifrNQehDbSM9K+N6ae+xxTY=";
  };

  # no tests are defined in 1.3.5
  doCheck = false;
  pythonImportsCheck = [ "simplekml" ];

  meta = with lib; {
    description = "Python package to generate KML";
    homepage = "https://simplekml.readthedocs.io/";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ rvolosatovs ];
  };
}
