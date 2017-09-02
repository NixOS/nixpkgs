{ stdenv, buildPythonPackage, fetchPypi
, coverage, tornado, mock, nose, psutil, pysocks }:

buildPythonPackage rec {
  pname = "urllib3";
  version = "1.22";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0kyvc9zdlxr5r96bng5rhm9a6sfqidrbvvkz64s76qs5267dli6c";
  };

  NOSE_EXCLUDE = stdenv.lib.concatStringsSep "," [
    "test_headers" "test_headerdict" "test_can_validate_ip_san" "test_delayed_body_read_timeout"
    "test_timeout_errors_cause_retries" "test_select_multiple_interrupts_with_event"
  ];

  checkPhase = ''
    nosetests -v --cover-min-percentage 1
  '';

  doCheck = false;

  buildInputs = [ coverage tornado mock nose psutil pysocks ];

  meta = with stdenv.lib; {
    description = "A Python library for Dropbox's HTTP-based Core and Datastore APIs";
    homepage = https://www.dropbox.com/developers/core/docs;
    license = licenses.mit;
  };
}
