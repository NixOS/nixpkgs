{ lib, buildPythonPackage, fetchPypi
, requests }:

buildPythonPackage rec {
  pname = "yubico-client";
  version = "1.11.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c1d1c1f918c058932493c5a50341583e48487264129ed5b973c327ae48afed87";
  };

  propagatedBuildInputs = [ requests ];

  # pypi package missing test_utils and github releases is behind
  doCheck = false;

  meta = with lib; {
    description = "Verifying Yubico OTPs based on the validation protocol version 2.0";
    homepage = https://github.com/Kami/python-yubico-client/;
    maintainers= with maintainers; [ peterromfeldhk ];
    license = licenses.bsd3;
  };
}
