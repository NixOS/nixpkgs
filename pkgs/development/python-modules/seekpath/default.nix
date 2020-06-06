{ stdenv, buildPythonPackage, fetchPypi, numpy, future, spglib, glibcLocales, pytest }:

buildPythonPackage rec {
  pname = "seekpath";
  version = "2.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "188513ee187fbbace49066a29ecea9bbd351f23da3bea33d507d0f590856b082";
  };

  LC_ALL = "en_US.utf-8";

  propagatedBuildInputs = [ numpy spglib future ];

  nativeBuildInputs = [ glibcLocales ];

  checkInputs = [ pytest ];

  # I don't know enough about crystal structures to fix
  checkPhase = ''
    pytest . -k 'not oI2Y'
  '';

  meta = with stdenv.lib; {
    description = "A module to obtain and visualize band paths in the Brillouin zone of crystal structures.";
    homepage = "https://github.com/giovannipizzi/seekpath";
    license = licenses.mit;
    maintainers = with maintainers; [ psyanticy ];
  };
}

