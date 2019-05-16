{ stdenv, buildPythonPackage, pythonOlder, fetchPypi, nose }:

buildPythonPackage rec {
  pname = "yanc";
  version = "0.3.3";

  # Tests fail on Python>=3.5. See: https://github.com/0compute/yanc/issues/10
  disabled = !(pythonOlder "3.5");

  checkInputs = [ nose ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "0z35bkk9phs40lf5061k1plhjdl5fskm0dmdikrsqi1bjihnxp8w";
  };

  checkPhase = ''
    nosetests .
  '';

  meta = with stdenv.lib; {
    description = "Yet another nose colorer";
    homepage = https://github.com/0compute/yanc;
    license = licenses.gpl3;
    maintainers = with maintainers; [ jluttine ];
  };
}
