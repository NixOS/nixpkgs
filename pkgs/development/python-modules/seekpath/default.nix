{ stdenv, buildPythonPackage, fetchPypi, numpy, future, spglib, glibcLocales }:

buildPythonPackage rec {
  pname = "seekpath";
  version = "1.8.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0bdc0400c96952525b1165894807e4bec90aaedb11cfeb27a57414e6091eb026";
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

