{ buildPythonPackage, fetchPypi, lib }:

buildPythonPackage rec {
  pname = "teletype";
  version = "1.3.2";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-9q46a4ui2kgSUL/vImR02r4T9huwLFwd70AqGBNJNzs=";
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
