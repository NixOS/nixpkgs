{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  pycryptodome,
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "sjcl";
  version = "0.2.1";

  format = "setuptools";

  # PyPi release is missing tests
  src = fetchFromGitHub {
    owner = "berlincode";
    repo = pname;
    # commit from: 2018-08-16, because there aren't any tags on git
    rev = "e8bdad312fa99c89c74f8651a1240afba8a9f3bd";
    sha256 = "1v8rc55v28v8cl7nxcavj34am005wi63zcvwnbc6pyfbv4ss30ab";
  };

  propagatedBuildInputs = [ pycryptodome ];

  nativeCheckInputs = [ unittestCheckHook ];

  pythonImportsCheck = [ "sjcl" ];

  meta = with lib; {
    description = "Decrypt and encrypt messages compatible to the \"Stanford Javascript Crypto Library (SJCL)\" message format. This is a wrapper around pycrypto";
    homepage = "https://github.com/berlincode/sjcl";
    license = licenses.bsd3;
    maintainers = with maintainers; [ binsky ];
  };
}
