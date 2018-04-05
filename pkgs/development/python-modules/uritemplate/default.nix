{ lib, buildPythonPackage, fetchPypi, simplejson }:

buildPythonPackage rec {
  pname = "uritemplate";
  version = "3.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c02643cebe23fc8adb5e6becffe201185bf06c40bda5c0b4028a93f1527d011d";
  };

  # No tests in archive
  doCheck = false;

  propagatedBuildInputs = [ simplejson ];

  meta = with lib; {
    homepage = https://github.com/uri-templates/uritemplate-py;
    description = "Python implementation of URI Template";
    license = licenses.asl20;
    maintainers = with maintainers; [ matthiasbeyer ];
  };
}
