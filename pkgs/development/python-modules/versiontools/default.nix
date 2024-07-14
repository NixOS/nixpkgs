{
  lib,
  buildPythonPackage,
  fetchPypi,
  isPy3k,
}:

buildPythonPackage rec {
  pname = "versiontools";
  version = "1.9.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-qWkzKIehipyYsN8OpNTKdZcvJMqU8G+4fVkTd+g0FPY=";
  };

  doCheck = (!isPy3k);

  meta = with lib; {
    homepage = "https://launchpad.net/versiontools";
    description = "Smart replacement for plain tuple used in __version__";
    license = licenses.lgpl2;
  };
}
