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
  version = "1.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "08fb86b5ab469bafdbef19751abb6dc1e08a3043c373ea915e1b6e20d023b529";
  };

  postPatch = ''
    substituteInPlace setup.py --replace ",<19.3" ""
  '';

  # No tests in archive.
  doCheck = false;

  disabled = pythonOlder "3.6";

  propagatedBuildInputs = [ attrs pendulum pprintpp wrapt ];

  meta = {
    homepage = https://github.com/thebigmunch/tbm-utils;
    license = with lib.licenses; [ mit ];
    description = "A commonly-used set of utilities";
  };

}
