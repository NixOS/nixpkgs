{ lib, buildPythonPackage, fetchFromGitHub
, elementpath
, lxml
, pytest
}:

buildPythonPackage rec {
  version = "1.2.2";
  pname = "xmlschema";

  src = fetchFromGitHub {
    owner = "sissaschool";
    repo = "xmlschema";
    rev = "v${version}";
    sha256 = "04rlcm5777cv7aw9mf0z1xrj8cn2rljfzs9i2za6sdk6h1ngpj3q";
  };

  propagatedBuildInputs = [ elementpath ];

  checkInputs = [ lxml pytest ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "elementpath~=1.4.0" "elementpath~=1.4"
  '';

  # Ignore broken fixtures, and tests for files which don't exist.
  # For darwin, we need to explicity say we can't reach network
  checkPhase = ''
    pytest tests \
      --ignore=tests/test_factory.py \
      --ignore=tests/test_schemas.py \
      --ignore=tests/test_memory.py \
      --ignore=tests/test_validation.py \
      -k 'not element_tree_import_script'
  '';

  meta = with lib; {
    description = "XML Schema validator and data conversion library for Python";
    homepage = "https://github.com/sissaschool/xmlschema";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
