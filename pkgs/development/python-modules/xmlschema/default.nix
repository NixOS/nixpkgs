{ lib, buildPythonPackage, fetchFromGitHub
, elementpath
, lxml
, pytest
}:

buildPythonPackage rec {
  version = "1.2.3";
  pname = "xmlschema";

  src = fetchFromGitHub {
    owner = "sissaschool";
    repo = "xmlschema";
    rev = "v${version}";
    sha256 = "1lasi84d5v66xpd40fbj3lqwc5hfh3izxrr2wbfdbj4a3m996zc9";
  };

  propagatedBuildInputs = [ elementpath ];

  checkInputs = [ lxml pytest ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "elementpath~=2.0.0" "elementpath~=2.0"
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
