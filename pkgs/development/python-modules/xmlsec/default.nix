{
  lib,
  buildPythonPackage,
  fetchPypi,
  hypothesis,
  libtool,
  libxml2,
  libxslt,
  lxml,
  pkg-config,
  pkgconfig,
  pytestCheckHook,
  setuptools-scm,
  xmlsec,
}:

buildPythonPackage rec {
  pname = "xmlsec";
  version = "1.3.16";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-K2xwVExtHUygBqqjFJWODvNRTcgf/94bI/LsQaV5H50=";
  };

  build-system = [ setuptools-scm ];

  nativeBuildInputs = [
    pkg-config
    pkgconfig
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
    changelog = "https://github.com/xmlsec/python-xmlsec/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ zhaofengli ];
  };
}
