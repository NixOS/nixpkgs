{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "strict-rfc3339";
  version = "0.7";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-XK0Xvt/Dr1ezmdsP7TJ3Hxj8VLvZF+hVRgiGB6xeEnc=";
  };

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/danielrichman/strict-rfc3339";
    license = licenses.gpl3;
    description = "Strict, simple, lightweight RFC3339 functions";
    maintainers = with maintainers; [ vanschelven ];
  };
}
