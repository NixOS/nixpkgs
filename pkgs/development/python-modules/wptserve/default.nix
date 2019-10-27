{ lib
, buildPythonPackage
, fetchPypi
, six, h2
, isPy3k
}:

buildPythonPackage rec {
  pname = "wptserve";
  version = "2.0";

  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "9d0c6adc279748abea81ac12b7a2cac97ebbdd87826dc11f6dbd85b781e9442a";
  };

  postPatch = ''
    substituteInPlace setup.py --replace "h2==" "h2>="
  '';

  propagatedBuildInputs = [ six h2 ];

  meta = {
    description = "A webserver intended for web browser testing";
    homepage =  https://wptserve.readthedocs.org/;
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ raskin ];
  };
}
