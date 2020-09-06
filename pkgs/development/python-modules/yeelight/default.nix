{ stdenv, fetchPypi, buildPythonPackage, future, enum-compat }:

buildPythonPackage rec {
  pname = "yeelight";
  version = "0.5.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8d49846f0cede1e312cbcd1d0e44c42073910bbcadb31b87ce2a7d24dea3af38";
  };

  propagatedBuildInputs = [ future enum-compat ];

  meta = with stdenv.lib; {
    description = "A Python library for controlling YeeLight RGB bulbs";
    homepage = "https://gitlab.com/stavros/python-yeelight/";
    license = licenses.asl20;
    maintainers = with maintainers; [ nyanloutre ];
  };
}
