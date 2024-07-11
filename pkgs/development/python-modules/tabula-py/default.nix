{
  lib,
  buildPythonPackage,
  distro,
  fetchFromGitHub,
  jre,
  numpy,
  pandas,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  setuptools-scm,
  jpype1,
}:

buildPythonPackage rec {
  pname = "tabula-py";
  version = "2.9.3";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "chezou";
    repo = "tabula-py";
    rev = "refs/tags/v${version}";
    hash = "sha256-dEcVIlK3M7zqRMN7W7mnnMPWhM2A4/qvf0aY61ko4yE=";
  };

  postPatch = ''
    substituteInPlace tabula/backend.py \
      --replace-fail '"java"' '"${lib.getExe jre}"'
  '';

  build-system = [
    setuptools
    setuptools-scm
  ];

  buildInputs = [ jre ];

  dependencies = [
    distro
    numpy
    pandas
    jpype1
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "tabula" ];

  disabledTests = [
    # Tests require network access
    "test_convert_remote_file"
    "test_read_pdf_with_remote_template"
    "test_read_remote_pdf"
    "test_read_remote_pdf_with_custom_user_agent"
    # not sure what it checks
    # probably related to jpype, but we use subprocess instead
    # https://github.com/chezou/tabula-py/issues/352#issuecomment-1730791540
    # Failed: DID NOT RAISE <class 'RuntimeError'>
    "test_read_pdf_with_silent_true"
  ];

  meta = with lib; {
    description = "Module to extract table from PDF into pandas DataFrame";
    homepage = "https://github.com/chezou/tabula-py";
    changelog = "https://github.com/chezou/tabula-py/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
