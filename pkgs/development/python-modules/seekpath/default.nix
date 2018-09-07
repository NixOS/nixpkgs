{ stdenv, buildPythonPackage, fetchPypi, numpy, future, spglib, glibcLocales }:

buildPythonPackage rec {
  pname = "seekpath";
  version = "1.8.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8fb22231ed6fc6aa12e2f2cc6c8ca67b82648e16c1c85ddac2e2237ac4553d83";
  };  

  LC_ALL = "en_US.utf-8";

  propagatedBuildInputs = [ numpy spglib future ];

  nativeBuildInputs = [ glibcLocales ];

  meta = with stdenv.lib; {
    description = "A module to obtain and visualize band paths in the Brillouin zone of crystal structures.";
    homepage = https://github.com/giovannipizzi/seekpath;
    license = licenses.mit;
    maintainers = with maintainers; [ psyanticy ];
  };
}

