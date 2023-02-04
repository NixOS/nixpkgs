{ lib
, fetchPypi
, buildPythonPackage
, pytestCheckHook
, libxslt
, libxml2
, libtool
, pkg-config
, xmlsec
, pkgconfig
, setuptools-scm
, lxml
, hypothesis
}:

buildPythonPackage rec {
  pname = "xmlsec";
  version = "1.3.13";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-kW9deOgEH2zZORq7plnajJSk/vcZbRJtQK8f9Bfyz4Y=";
  };

  nativeBuildInputs = [ pkg-config pkgconfig setuptools-scm ];

  buildInputs = [ xmlsec libxslt libxml2 libtool ];

  propagatedBuildInputs = [ lxml ];

  nativeCheckInputs = [ pytestCheckHook hypothesis ];

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
