{ stdenv, buildPythonPackage, fetchPypi
, pytest, mock, tornado, pyopenssl, cryptography
, idna, certifi, ipaddress, pysocks }:

buildPythonPackage rec {
  pname = "urllib3";
  version = "1.24.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9a247273df709c4fedb38c711e44292304f73f39ab01beda9f6b9fc375669ac3";
  };

  NOSE_EXCLUDE = stdenv.lib.concatStringsSep "," [
    "test_headers" "test_headerdict" "test_can_validate_ip_san" "test_delayed_body_read_timeout"
    "test_timeout_errors_cause_retries" "test_select_multiple_interrupts_with_event"
  ];

  checkPhase = ''
    nosetests -v --cover-min-percentage 1
  '';

  doCheck = false;

  checkInputs = [ pytest mock tornado ];
  propagatedBuildInputs = [ pyopenssl cryptography idna certifi ipaddress pysocks ];

  meta = with stdenv.lib; {
    description = "Powerful, sanity-friendly HTTP client for Python";
    homepage = https://github.com/shazow/urllib3;
    license = licenses.mit;
  };
}
