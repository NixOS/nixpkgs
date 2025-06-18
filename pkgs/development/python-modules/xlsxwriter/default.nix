{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "xlsxwriter";
  version = "3.2.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "jmcnamara";
    repo = "XlsxWriter";
    rev = "RELEASE_${version}";
    hash = "sha256-bacoOZckZVADMa81raUV9z3V1xj2Eid7B+gLb+MCccg=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "xlsxwriter" ];

  meta = with lib; {
    description = "Module for creating Excel XLSX files";
    homepage = "https://xlsxwriter.readthedocs.io/";
    changelog = "https://xlsxwriter.readthedocs.io/changes.html";
    license = licenses.bsd2;
    maintainers = with maintainers; [ jluttine ];
    mainProgram = "vba_extract.py";
  };
}
