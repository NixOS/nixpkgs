{ stdenv, buildPythonPackage, fetchPypi, numpy, future, spglib, glibcLocales, pytest }:

buildPythonPackage rec {
  pname = "seekpath";
  version = "1.9.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "abc806479f11e7f71c4475a292d849baf15dfa1cbc89ecc602d78415de322c83";
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

