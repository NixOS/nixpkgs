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
  version = "3.2.5";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "jmcnamara";
    repo = "XlsxWriter";
    rev = "RELEASE_${version}";
    hash = "sha256-Z384IYFQzGViJXJQe+zovXn5X+MyOqGv0NKKlktcF4o=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "xlsxwriter" ];

<<<<<<< HEAD
  meta = {
    description = "Module for creating Excel XLSX files";
    homepage = "https://xlsxwriter.readthedocs.io/";
    changelog = "https://xlsxwriter.readthedocs.io/changes.html";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ jluttine ];
=======
  meta = with lib; {
    description = "Module for creating Excel XLSX files";
    homepage = "https://xlsxwriter.readthedocs.io/";
    changelog = "https://xlsxwriter.readthedocs.io/changes.html";
    license = licenses.bsd2;
    maintainers = with maintainers; [ jluttine ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "vba_extract.py";
  };
}
