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
, toml
, lxml
, hypothesis
}:

buildPythonPackage rec {
  pname = "xmlsec";
  version = "1.3.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1c4k42zv3plm6v65p7z6l5rxyf50h40d02nhc16vq7cjrfvdf4rx";
  };

  # https://github.com/mehcode/python-xmlsec/issues/84#issuecomment-632930116
  patches = [
    ./reset-lxml-in-tests.patch
  ];

  nativeBuildInputs = [ pkg-config pkgconfig setuptools-scm toml ];

  buildInputs = [ xmlsec libxslt libxml2 libtool ];

  propagatedBuildInputs = [ lxml ];

  # Full git clone required for test_doc_examples
  checkInputs = [ pytestCheckHook hypothesis ];
  disabledTestPaths = [ "tests/test_doc_examples.py" ];

  meta = with lib; {
    description = "Python bindings for the XML Security Library";
    homepage = "https://github.com/mehcode/python-xmlsec";
    license = licenses.mit;
    maintainers = with maintainers; [ zhaofengli ];
  };
}
