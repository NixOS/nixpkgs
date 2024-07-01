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
    sha256 = "cda687be2754395fcab664e908ebf589facd41e8436d233d2be37a69efb1c536";
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
