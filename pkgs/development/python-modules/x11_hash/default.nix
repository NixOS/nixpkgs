{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec{
  version = "1.4";
  pname = "x11_hash";

  src = fetchPypi {
    inherit pname version;
    sha256 = "172skm9xbbrivy1p4xabxihx9lsnzi53hvzryfw64m799k2fmp22";
  };

  meta = with stdenv.lib; {
    description = "Binding for X11 proof of work hashing";
    homepage = https://github.com/mazaclub/x11_hash;
    license = licenses.mit;
    maintainers = with maintainers; [ np ];
  };

}
