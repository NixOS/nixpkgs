{ stdenv
, buildPythonPackage
, fetchPypi
, lib
, python
, isPy27
, isPy33
, enum34
}:

buildPythonPackage rec {
  pname = "serpent";
  version = "1.28";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f306336ca09aa38e526f3b03cab58eb7e45af09981267233167bcf3bfd6436ab";
  };

  propagatedBuildInputs = lib.optionals (isPy27 || isPy33) [ enum34 ];

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
