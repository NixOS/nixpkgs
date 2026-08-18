{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "xlsxwriter";
  version = "3.2.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jmcnamara";
    repo = "XlsxWriter";
    tag = "RELEASE_${version}";
    hash = "sha256-nr7Qw24BzQo/qEpyM9687mUaebzzHv1FAPmsBVdMekg=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "xlsxwriter" ];

  meta = {
    description = "Module for creating Excel XLSX files";
    homepage = "https://xlsxwriter.readthedocs.io/";
    changelog = "https://xlsxwriter.readthedocs.io/changes.html";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ jluttine ];
    mainProgram = "vba_extract.py";
  };
}
