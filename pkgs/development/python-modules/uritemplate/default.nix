{ lib, buildPythonPackage, fetchPypi, simplejson, pytest, glibcLocales }:

buildPythonPackage rec {
  pname = "uritemplate";
  version = "3.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c02643cebe23fc8adb5e6becffe201185bf06c40bda5c0b4028a93f1527d011d";
  };

  propagatedBuildInputs = [ simplejson ];

  checkInputs = [ pytest glibcLocales ];

  checkPhase = ''
    LC_ALL=en_US.UTF-8 py.test
  '';

  meta = with lib; {
    homepage = https://github.com/python-hyper/uritemplate;
    description = "URI template parsing for Humans";
    license = with licenses; [ asl20 bsd3 ];
    maintainers = with maintainers; [ matthiasbeyer ];
  };
}
