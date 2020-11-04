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
  version = "2.6.0";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "235748cceeb22c042e32d2fdfd4d710021bac9b938c4f2c35e1fce1cfd58f7ec";
  };

  propagatedBuildInputs = [ attrs pendulum pprintpp wrapt ];

  # this versioning was done to prevent normal pip users from encountering
  # issues with package failing to build from source, but nixpkgs is better
  postPatch = ''
    substituteInPlace setup.py \
      --replace "pendulum>=2.0,<=3.0,!=2.0.5,!=2.1.0" "pendulum>=2.0,<=3.0"
  '';

  # No tests in archive.
  doCheck = false;

  meta = {
    description = "A commonly-used set of utilities";
    homepage = "https://github.com/thebigmunch/tbm-utils";
    license = with lib.licenses; [ mit ];
  };

}
