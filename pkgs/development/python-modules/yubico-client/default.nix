{
  lib,
  buildPythonPackage,
  fetchPypi,
  requests,
}:

buildPythonPackage rec {
  pname = "yubico-client";
  version = "1.13.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-47hs0qEjEF7frK1AVRx7JunBGT2B/+Fo7nBOv9PREWI=";
  };

  propagatedBuildInputs = [ requests ];

  # pypi package missing test_utils and github releases is behind
  doCheck = false;

  meta = with lib; {
    description = "Verifying Yubico OTPs based on the validation protocol version 2.0";
    homepage = "https://github.com/Kami/python-yubico-client/";
    maintainers = with maintainers; [ peterromfeldhk ];
    license = licenses.bsd3;
  };
}
