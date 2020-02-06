{ lib, buildPythonPackage, fetchPypi
, requests }:

buildPythonPackage rec {
  pname = "yubico-client";
  version = "1.12.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1d74c6341210c94b639f7c7c8930550e73d5c1be60402e418e9dc95e038f8527";
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
