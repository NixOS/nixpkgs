{ lib
, buildPythonPackage
, fetchFromGitHub
, characteristic
, pyasn1
, pyasn1-modules
, pyopenssl
, idna
, attrs
, pytest
}:

buildPythonPackage rec {
  pname = "service_identity";
  version = "17.0.0";

  src = fetchFromGitHub {
    owner = "pyca";
    repo = pname;
    rev = version;
    sha256 = "1fn332fci776m5a7jx8c1jgbm27160ip5qvv8p01c242ag6by5g0";
  };

  propagatedBuildInputs = [
    characteristic pyasn1 pyasn1-modules pyopenssl idna attrs
  ];

  checkInputs = [ pytest ];
  checkPhase = "py.test";

  meta = with lib; {
    description = "Service identity verification for pyOpenSSL";
    license = licenses.mit;
    homepage = https://service-identity.readthedocs.io;
  };
}
