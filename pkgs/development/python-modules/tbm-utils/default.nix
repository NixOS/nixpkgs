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
  version = "2.5.0";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "02bmra9f0p1irhbrklxk9nhkvgwkn8042hx7z6c00qlhac1wlba2";
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
