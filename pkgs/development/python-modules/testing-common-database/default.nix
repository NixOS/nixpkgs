{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "testing.common.database";
  version = "2.0.3";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ll2AsphTFTJdw1jDBhsXSnEvTU1b9qgLWLEfmh3YbXM=";
  };

  postPatch = ''
    substituteInPlace src/testing/common/database.py \
      --replace "collections.Callable" "collections.abc.Callable"
  '';

  # There are no unit tests
  doCheck = false;

  meta = with lib; {
    description = "utilities for testing.* packages";
    homepage = "https://github.com/tk0miya/testing.common.database";
    license = licenses.asl20;
    maintainers = with maintainers; [ jluttine ];
  };
}
