{ lib, buildPythonPackage, fetchPypi, simplejson, pytest, glibcLocales }:

buildPythonPackage rec {
  pname = "uritemplate";
  version = "3.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5af8ad10cec94f215e3f48112de2022e1d5a37ed427fbd88652fa908f2ab7cae";
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
