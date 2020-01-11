{ stdenv, buildPythonPackage, fetchPypi
}:

buildPythonPackage rec {
  pname = "shellingham";
  version = "1.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1q7kws7w4x2hji3g7y0ni9ddk4sd676ylrb3db54gbpys6xj6nwq";
  };

  meta = with stdenv.lib; {
    description = "Tool to Detect Surrounding Shell";
    homepage = https://github.com/sarugaku/shellingham;
    license = licenses.isc;
    maintainers = with maintainers; [ mbode ];
  };
}
