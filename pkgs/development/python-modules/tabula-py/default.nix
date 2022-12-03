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
  version = "2.5.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "chezou";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-Dfi6LzrLDz9VVDmbeK1dEaWuQosD4tvAH13Q4Mp3smA=";
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

  checkInputs = [
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
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
