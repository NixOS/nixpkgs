{ lib, buildPythonPackage, fetchFromGitHub
, elementpath
, pytest
}:

buildPythonPackage rec {
  version = "1.0.13";
  pname = "xmlschema";

  src = fetchFromGitHub {
    owner = "sissaschool";
    repo = "xmlschema";
    rev = "v${version}";
    sha256 = "182439gqhlxhr9rdi9ak33z4ffy1w9syhykkckkl6mq050c80qdr";
  };

  propagatedBuildInputs = [ elementpath ];

  checkInputs = [ pytest ];

  # Ignore broken fixtures, and tests for files which don't exist.
  # For darwin, we need to explicity say we can't reach network
  checkPhase = ''
    substituteInPlace xmlschema/tests/__init__.py \
      --replace "SKIP_REMOTE_TESTS = " "SKIP_REMOTE_TESTS = True #"
    pytest . \
      --ignore=xmlschema/tests/test_factory.py \
      --ignore=xmlschema/tests/test_validators.py \
      --ignore=xmlschema/tests/test_schemas.py \
      -k 'not element_tree_import_script'
  '';

  meta = with lib; {
    description = "XML Schema validator and data conversion library for Python";
    homepage = "https://github.com/sissaschool/xmlschema";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
