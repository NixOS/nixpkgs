{
  lib,
  buildPythonPackage,
  fetchPypi,
  isPyPy,
  python,
  python-dateutil,
}:

buildPythonPackage rec {
  version = "0.9.8";
  format = "setuptools";
  pname = "vobject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-2wCn9NtJOXFV3YpoceiioBdabrpaZUww6RD4KylRS1g=";
  };

  disabled = isPyPy;

  propagatedBuildInputs = [ python-dateutil ];

  checkPhase = "${python.interpreter} tests.py";

  meta = with lib; {
    description = "Module for reading vCard and vCalendar files";
    homepage = "http://eventable.github.io/vobject/";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
