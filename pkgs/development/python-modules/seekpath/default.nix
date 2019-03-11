{ stdenv, buildPythonPackage, fetchPypi, numpy, future, spglib, glibcLocales }:

buildPythonPackage rec {
  pname = "seekpath";
  version = "1.8.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b61dadba82acc0838402981b7944155adc092b114ca81f53f61b1d498a512e3a";
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

