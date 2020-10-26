{ stdenv
, buildPythonPackage
, fetchPypi
, lib
, python
, isPy27
, enum34
, attrs
, pytz
}:

buildPythonPackage rec {
  pname = "serpent";
  version = "1.30.2";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "72753820246a7d8486e8b385353e3bbf769abfceec2e850fa527a288b084ff7a";
  };

  checkInputs = [ attrs pytz ];
  checkPhase = ''
    ${python.interpreter} setup.py test
  '';

  meta = with stdenv.lib; {
    description = "A simple serialization library based on ast.literal_eval";
    homepage = "https://github.com/irmen/Serpent";
    license = licenses.mit;
    maintainers = with maintainers; [ prusnak ];
    };
}
