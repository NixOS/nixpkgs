{ lib
, buildPythonPackage
, fetchPypi
, attrs
, pendulum
, pprintpp
, wrapt
, pythonOlder
}:

buildPythonPackage rec {
  pname = "tbm-utils";
  version = "2.5.1";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5909852f8ce350631cdaaecaf0aee45569148d22bd429360a1c92a203ba5706b";
  };

  propagatedBuildInputs = [ attrs pendulum pprintpp wrapt ];

  # No tests in archive.
  doCheck = false;

  meta = {
    description = "A commonly-used set of utilities";
    homepage = "https://github.com/thebigmunch/tbm-utils";
    license = with lib.licenses; [ mit ];
  };

}
