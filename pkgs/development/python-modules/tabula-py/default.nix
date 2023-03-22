{ lib
, buildPythonPackage
, distro
, fetchFromGitHub
, jre
, numpy
, pandas
, pytestCheckHook
, pythonOlder
, setuptools-scm
, setuptools
}:

buildPythonPackage rec {
  pname = "tabula-py";
  version = "2.7.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "chezou";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-SV4QLvk7dXtU0/husS5A5mBYvbTejLyO9PpiO2oBtjs=";
  };

  patches = [
    ./java-interpreter-path.patch
  ];

  postPatch = ''
    sed -i 's|@JAVA@|${jre}/bin/java|g' $(find -name '*.py')
  '';

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    distro
    numpy
    pandas
    setuptools
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "tabula"
  ];

  disabledTests = [
    # Tests require network access
    "test_convert_remote_file"
    "test_read_pdf_with_remote_template"
    "test_read_remote_pdf"
    "test_read_remote_pdf_with_custom_user_agent"
  ];

  meta = with lib; {
    description = "Module to extract table from PDF into pandas DataFrame";
    homepage = "https://github.com/chezou/tabula-py";
    changelog = "https://github.com/chezou/tabula-py/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
