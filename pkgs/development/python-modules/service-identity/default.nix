{ lib
, attrs
, buildPythonPackage
, cryptography
, fetchFromGitHub
, idna
, pyasn1
, pyasn1-modules
, six
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "service-identity";
  version = "21.1.0";

  src = fetchFromGitHub {
    owner = "pyca";
    repo = pname;
    rev = version;
    sha256 = "sha256-pWc2rU3ULqEukMhd1ySY58lTm3s8f/ayQ7CY4nG24AQ=";
  };

  propagatedBuildInputs = [
    attrs
    cryptography
    idna
    pyasn1
    pyasn1-modules
    six
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "service_identity" ];

  meta = with lib; {
    description = "Service identity verification for pyOpenSSL";
    homepage = "https://service-identity.readthedocs.io";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
