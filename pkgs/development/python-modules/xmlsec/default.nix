{
  lib,
  fetchPypi,
  buildPythonPackage,
  pytestCheckHook,
  libxslt,
  libxml2,
  libtool,
  pkg-config,
  xmlsec,
  pkgconfig,
  setuptools-scm,
  lxml,
  hypothesis,
}:

buildPythonPackage rec {
  pname = "xmlsec";
  version = "1.3.14";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-k0+ATy+JW824bx6u4ja2YQE1YO5p7BCNKc3W5fKSotk=";
  };

  nativeBuildInputs = [
    pkg-config
    pkgconfig
    setuptools-scm
  ];

  buildInputs = [
    xmlsec
    libxslt
    libxml2
    libtool
  ];

  propagatedBuildInputs = [ lxml ];

  nativeCheckInputs = [
    pytestCheckHook
    hypothesis
  ];

  disabledTestPaths = [
    # Full git clone required for test_doc_examples
    "tests/test_doc_examples.py"
    # test_reinitialize_module segfaults python
    # https://github.com/mehcode/python-xmlsec/issues/203
    "tests/test_xmlsec.py"
  ];

  pythonImportsCheck = [ "xmlsec" ];

  meta = with lib; {
    description = "Python bindings for the XML Security Library";
    homepage = "https://github.com/mehcode/python-xmlsec";
    license = licenses.mit;
    maintainers = with maintainers; [ zhaofengli ];
  };
}
