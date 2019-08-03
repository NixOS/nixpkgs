{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "SocksiPy-branch";
  version = "1.01";

  src = fetchPypi {
    inherit pname version;
    sha256 = "01l41v4g7fy9fzvinmjxy6zcbhgqaif8dhdqm4w90fwcw9h51a8p";
  };

  meta = with stdenv.lib; {
    homepage = http://code.google.com/p/socksipy-branch/;
    description = "This Python module allows you to create TCP connections through a SOCKS proxy without any special effort";
    license = licenses.bsd3;
  };

}
