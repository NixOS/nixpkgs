{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
  six,
}:

buildPythonPackage {
  pname = "xlwt";
  version = "1.3.0-unstable-2018-09-16";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "python-excel";
    repo = "xlwt";
    # Use last commit before archival
    rev = "5a222d0315b6d3ce52a3cedd7c3e41309587c107";
    hash = "sha256-YKbqdimX1q+d7A9BSwuKl3SndQ+0eocz+m6xMAZeMQQ=";
  };

  build-system = [ setuptools ];

  dependencies = [ six ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "xlwt" ];

  meta = {
    description = "Library to create spreadsheet files compatible with MS";
    homepage = "https://github.com/python-excel/xlwt";
    license = with lib.licenses; [
      bsdOriginal
      bsd3
      lgpl21Plus
    ];
    maintainers = with lib.maintainers; [ pyrox0 ];
  };
}
