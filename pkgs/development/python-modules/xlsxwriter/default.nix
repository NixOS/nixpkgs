{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "xlsxwriter";
  version = "3.2.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "jmcnamara";
    repo = "XlsxWriter";
    rev = "RELEASE_${version}";
    hash = "sha256-HLSIKoGBSzU7N/lskVeVbfdOezTloMrwAahJbcnqJrw=";
  };

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "xlsxwriter"
  ];

  meta = with lib; {
    description = "Module for creating Excel XLSX files";
    mainProgram = "vba_extract.py";
    homepage = "https://xlsxwriter.readthedocs.io/";
    changelog = "https://xlsxwriter.readthedocs.io/changes.html";
    license = licenses.bsd2;
    maintainers = with maintainers; [ jluttine ];
  };
}
