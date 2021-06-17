{ lib, buildPythonPackage, fetchFromGitHub
, elementpath
, lxml
, pytest
}:

buildPythonPackage rec {
  version = "1.6.4";
  pname = "xmlschema";

  src = fetchFromGitHub {
    owner = "sissaschool";
    repo = "xmlschema";
    rev = "v${version}";
    sha256 = "sha256-0KVGu163t3stCgx7aWW/Ggf6CUW2ZhOOnPU6FfGHfKA=";
  };

  propagatedBuildInputs = [ elementpath ];

  checkInputs = [ lxml pytest ];

  # Ignore broken fixtures, and tests for files which don't exist.
  # For darwin, we need to explicity say we can't reach network
  checkPhase = ''
    pytest tests \
      --ignore=tests/test_factory.py \
      --ignore=tests/test_schemas.py \
      --ignore=tests/test_memory.py \
      --ignore=tests/test_validation.py \
      -k 'not element_tree_import_script and not export_remote'
  '';

  meta = with lib; {
    description = "XML Schema validator and data conversion library for Python";
    homepage = "https://github.com/sissaschool/xmlschema";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
