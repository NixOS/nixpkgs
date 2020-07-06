{ stdenv, buildPythonPackage, fetchPypi, six, twisted }:

buildPythonPackage rec {
  pname = "txdbus";
  version = "1.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "eefcffa4efbf82ba11222f17f5989fe1b2b6ef57226ef896c4a7084c990ba217";
  };

  propagatedBuildInputs = [ six twisted ];
  pythonImportsCheck = [ "txdbus" ];

  meta = with stdenv.lib; {
    description = "Native Python implementation of DBus for Twisted";
    homepage = "https://github.com/cocagne/txdbus";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ geistesk ];
  };
}
