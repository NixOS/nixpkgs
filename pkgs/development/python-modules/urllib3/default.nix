{ lib, buildPythonPackage, fetchPypi
, pytest, mock, tornado, pyopenssl, cryptography
, idna, certifi, ipaddress, pysocks }:

buildPythonPackage rec {
  pname = "urllib3";
  version = "1.26.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "de3eedaad74a2683334e282005cd8d7f22f4d55fa690a2a1020a416cb0a47e73";
  };

  NOSE_EXCLUDE = lib.concatStringsSep "," [
    "test_headers" "test_headerdict" "test_can_validate_ip_san" "test_delayed_body_read_timeout"
    "test_timeout_errors_cause_retries" "test_select_multiple_interrupts_with_event"
  ];

  checkPhase = ''
    nosetests -v --cover-min-percentage 1
  '';

  doCheck = false;

  checkInputs = [ pytest mock tornado ];
  propagatedBuildInputs = [ pyopenssl cryptography idna certifi ipaddress pysocks ];

  meta = with lib; {
    description = "Powerful, sanity-friendly HTTP client for Python";
    homepage = "https://github.com/shazow/urllib3";
    license = licenses.mit;
  };
}
