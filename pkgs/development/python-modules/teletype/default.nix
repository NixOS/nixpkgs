{ buildPythonPackage, fetchPypi, lib }:

buildPythonPackage rec {
  pname = "teletype";
  version = "1.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "02mg0qmdf7hljq6jw1hwaid3hvkf70dfxgrxmpqybaxrph5pfg1y";
  };

  # no tests
  doCheck = false;
  pythonImportsCheck = [ "teletype" ];

  meta = with lib; {
    description = "A high-level cross platform tty library";
    homepage = "https://github.com/jkwill87/teletype";
    license = licenses.mit;
    maintainers = with maintainers; [ urlordjames ];
  };
}
