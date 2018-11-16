{ stdenv, buildPythonPackage, fetchPypi
}:

buildPythonPackage rec {
  pname = "shellingham";
  version = "1.2.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "06biyiwq9571mryzbr50am3mxpc3blscwqhiq8c66ac4xm3maszm";
  };

  meta = with stdenv.lib; {
    description = "Tool to Detect Surrounding Shell";
    homepage = https://github.com/sarugaku/shellingham;
    license = licenses.isc;
    maintainers = with maintainers; [ mbode ];
  };
}
