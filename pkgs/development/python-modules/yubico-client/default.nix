{ lib, buildPythonPackage, fetchPypi
, requests }:

buildPythonPackage rec {
  pname = "yubico-client";
  version = "1.10.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0skkmrpvpb1pwyqjf3lh9vq46xagvwdx9kagpdbba2v5dgrk34d1";
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
