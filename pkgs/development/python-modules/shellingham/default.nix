{ stdenv, buildPythonPackage, fetchPypi
}:

buildPythonPackage rec {
  pname = "shellingham";
  version = "1.2.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "115k1z2klgsvyzg4q5ip0iqxyb565pkchhf2fsr846k68gqcgrjn";
  };

  meta = with stdenv.lib; {
    description = "Tool to Detect Surrounding Shell";
    homepage = https://github.com/sarugaku/shellingham;
    license = licenses.isc;
    maintainers = with maintainers; [ mbode ];
  };
}
