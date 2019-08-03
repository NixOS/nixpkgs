{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, cryptography
, ipaddress
, pyasn1
, pyasn1-modules
, idna
, attrs
, pytest
}:

buildPythonPackage rec {
  pname = "service_identity";
  version = "18.1.0";

  src = fetchFromGitHub {
    owner = "pyca";
    repo = pname;
    rev = version;
    sha256 = "1aw475ksmd4vpl8cwfdcsw2v063nbhnnxpy633sb75iqp9aazhlx";
  };

  propagatedBuildInputs = [
    pyasn1 pyasn1-modules idna attrs cryptography
  ] ++ lib.optionals (pythonOlder "3.3") [ ipaddress ];

  checkInputs = [ pytest ];
  checkPhase = "py.test";

  meta = with lib; {
    description = "Service identity verification for pyOpenSSL";
    license = licenses.mit;
    homepage = https://service-identity.readthedocs.io;
  };
}
