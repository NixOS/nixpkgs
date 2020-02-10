{ lib, buildPythonPackage, fetchFromGitHub
, elementpath
, pytest
}:

buildPythonPackage rec {
  version = "1.1.0";
  pname = "xmlschema";

  src = fetchFromGitHub {
    owner = "sissaschool";
    repo = "xmlschema";
    rev = "v${version}";
    sha256 = "1h8321jb6q3dhlh3608y3f3sbbzfd3jg1psyirxkrm4w5xs3lbvy";
  };

  propagatedBuildInputs = [ elementpath ];

  checkInputs = [ pytest ];

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
