{ stdenv
, buildPythonPackage
, fetchPypi
, lib
, python
, isPy27
, isPy33
, enum34
, attrs
, pytz
}:

buildPythonPackage rec {
  pname = "serpent";
  version = "1.28";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1arnckykpkvv2qrp49l1k7q5mr5pisswl0rvdx98x8wsl1n361pk";
  };

  propagatedBuildInputs = lib.optionals (isPy27 || isPy33) [ enum34 ];

  checkInputs = [ attrs pytz ];
  checkPhase = ''
    ${python.interpreter} setup.py test
  '';

  meta = with stdenv.lib; {
    description = "A simple serialization library based on ast.literal_eval";
    homepage = https://github.com/irmen/Serpent;
    license = licenses.mit;
    maintainers = with maintainers; [ prusnak ];
    };
}
