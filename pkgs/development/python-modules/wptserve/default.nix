{ lib
, buildPythonPackage
, fetchPypi
, six, h2
, isPy3k
}:

let
  _h2 = h2;
in let
  h2 = _h2.overrideAttrs (x: {
    version = "3.0.1";
    src = fetchPypi {
      pname = "h2";
      version = "3.0.1";
      sha256 = "0r3f43r0v7sqgdjjg5ngw0dndk2v6cyd0jncpwya54m37y42z5mj";
    };
  });
in

buildPythonPackage rec {
  pname = "wptserve";
  version = "2.0";

  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "9d0c6adc279748abea81ac12b7a2cac97ebbdd87826dc11f6dbd85b781e9442a";
  };

  propagatedBuildInputs = [ six h2 ];

  meta = {
    description = "A webserver intended for web browser testing";
    homepage =  http://wptserve.readthedocs.org/;
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ raskin ];
  };
}
