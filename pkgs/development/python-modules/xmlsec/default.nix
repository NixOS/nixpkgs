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
  version = "1.3.12";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2c86ac6ce570c9e04f04da0cd5e7d3db346e4b5b1d006311606368f17c756ef9";
  };

  # https://github.com/mehcode/python-xmlsec/issues/84#issuecomment-632930116
  patches = [
    ./reset-lxml-in-tests.patch
  ];

  nativeBuildInputs = [ pkg-config pkgconfig setuptools-scm ];

  buildInputs = [ xmlsec libxslt libxml2 libtool ];

  propagatedBuildInputs = [ lxml ];

  checkInputs = [ pytestCheckHook hypothesis ];

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
