{ stdenv, buildPythonPackage, fetchPypi, six, twisted }:

buildPythonPackage rec {
  pname = "txdbus";
  version = "1.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0z41n1ikpdvk0nm8dbyh6g9bg781q4j6hg2b09b5k4wdqm17zxbg";
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
