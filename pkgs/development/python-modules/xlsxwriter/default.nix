{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "xlsxwriter";
  version = "3.1.7";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "jmcnamara";
    repo = "XlsxWriter";
    rev = "RELEASE_${version}";
    hash = "sha256-ZOKS9sTZvlopfIYOEhOk/rq4qtcMrNQ4Bwb8lDtKfxs=";
  };

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "xlsxwriter"
  ];

  meta = with lib; {
    description = "Module for creating Excel XLSX files";
    homepage = "https://xlsxwriter.readthedocs.io/";
    license = licenses.bsd2;
    maintainers = with maintainers; [ jluttine ];
  };
}
