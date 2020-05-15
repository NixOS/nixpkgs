{ stdenv
, buildPythonPackage
, fetchPypi
, python
, six
}:

buildPythonPackage rec {
  pname = "selectors34";
  version = "1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "09f5066337f8a76fb5233f267873f89a27a17c10bf79575954894bb71686451c";
  };

  propagatedBuildInputs = [ six ];

  checkPhase = ''
    ${python.interpreter} setup.py test
  '';

  meta = with stdenv.lib; {
    description = "A backport of the selectors module from Python 3.4";
    homepage = "https://github.com/berkerpeksag/selectors34";
    license = licenses.psfl;
    maintainers = with maintainers; [ prusnak ];
    };
}
