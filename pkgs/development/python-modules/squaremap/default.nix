{ stdenv
, buildPythonPackage
, isPy3k
, fetchPypi
}:

buildPythonPackage rec {
  pname = "squaremap";
  version = "1.0.4";
  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "feab6cb3b222993df68440e34825d8a16de2c74fdb290ae3974c86b1d5f3eef8";
  };

  meta = with stdenv.lib; {
    description = "Hierarchic visualization control for wxPython";
    homepage = https://launchpad.net/squaremap;
    license = licenses.bsd3;
  };

}
