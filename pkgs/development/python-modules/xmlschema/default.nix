{ lib, buildPythonPackage, fetchFromGitHub
, elementpath
, lxml
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "xmlschema";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "sissaschool";
    repo = "xmlschema";
    rev = "v${version}";
    sha256 = "1yd7whf74z8bw99gldxlnrs8bjnjzald29b5cf2ka0i144sxbvad";
  };

  propagatedBuildInputs = [ elementpath ];

  checkInputs = [ lxml pytestCheckHook ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "elementpath~=2.0.0" "elementpath~=2.0"
  '';

  pytestFlagsArray = [ "tests" ];

  # Ignore broken fixtures, and tests for files which don't exist.
  # For darwin, we need to explicity say we can't reach network
  disabledTestPaths = [
    "tests/test_factory.py"
    "tests/test_schemas.py"
    "tests/test_memory.py"
    "tests/test_validation.py"
  ];

  disabledTests = [
    "element_tree_import_script"
    "export_remote"
  ];

  meta = with lib; {
    description = "XML Schema validator and data conversion library for Python";
    homepage = "https://github.com/sissaschool/xmlschema";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
