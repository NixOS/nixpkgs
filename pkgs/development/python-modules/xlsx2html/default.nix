{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "xlsx2html";
  version = "0.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1qd63la7jdrnshshbs7vfy9bsksxz96qgqf8pqkvycrz8qlh36ai";
  };

  propagatedBuildInputs = [
    six
    openpyxl
    Babel
    packaging
  ];

  meta = with lib; {
    homepage = "https://github.com/Apkawa/xlsx2html";
    description = "A simple export from xlsx format to html tables with keep cell formatting";
    license = licenses.mit;
    maintainers = with maintainers; [ ryneeverett ];
  };
}
