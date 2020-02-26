{ stdenv
, buildPythonPackage
, fetchFromGitHub
, requests
, cryptography
, suds-jurko
, pytest
}:

buildPythonPackage rec {
  pname = "transip-api";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "benkonrath";
    repo = pname;
    rev = "v${version}";
    sha256 = "153x8ph7cp432flaqiy2zgp060ddychcqcrssxkcmjvbm86xrz17";
  };

  checkInputs = [ pytest ];

  # Constructor Tests require network access
  checkPhase = ''
    pytest --deselect=tests/service_tests/test_domain.py::TestDomainService::test_constructor \
           --deselect tests/service_tests/test_vps.py::TestVPSService::testConstructor \
           --deselect tests/service_tests/test_webhosting.py::TestWebhostingService::testConstructor
  '';


  propagatedBuildInputs = [ requests cryptography suds-jurko ];

  meta = with stdenv.lib; {
    description = "TransIP API Connector";
    homepage = https://github.com/benkonrath/transip-api;
    license = licenses.mit;
    maintainers = with maintainers; [ flyfloh ];
  };
}
