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
  version = "1.27";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6f8dc4317fb5b5a9629b5e518846bc9fee374b8171533726dc68df52b36ee912";
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
