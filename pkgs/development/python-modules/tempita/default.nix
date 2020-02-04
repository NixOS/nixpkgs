{ lib, buildPythonPackage, fetchurl, nose }:

buildPythonPackage {
  version = "0.5.3";
  pname = "tempita";

  src = fetchurl {
    url = https://bitbucket.org/ianb/tempita/get/97392d008cc8.tar.gz;
    sha256 = "0nxnkxjvfyxygmws2zxql590mwqsqd1rnhy80m9nbpdh81p7vh9y";
  };

  buildInputs = [ nose ];

  meta = {
    homepage = http://pythonpaste.org/tempita/;
    description = "A very small text templating language";
    license = lib.licenses.mit;
  };
}
