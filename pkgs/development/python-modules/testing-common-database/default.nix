{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "testing.common.database";
  version = "2.0.3";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ll2AsphTFTJdw1jDBhsXSnEvTU1b9qgLWLEfmh3YbXM=";
  };

  postPatch = ''
    substituteInPlace src/testing/common/database.py \
      --replace-fail "collections.Callable" "collections.abc.Callable"
  '';

  build-system = [ setuptools ];

  # There are no unit tests
  doCheck = false;

  meta = {
    description = "Utilities for testing.* packages";
    homepage = "https://github.com/tk0miya/testing.common.database";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ jluttine ];
  };
}
