{
  buildPythonPackage,
  fetchPypi,
  lib,
  setuptools,
}:

buildPythonPackage rec {
  pname = "types-futures";
  version = "3.3.8";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    sha256 = "6fe8ccc2c2af7ef2fdd9bf73eab6d617074f09f30ad7d373510b4043d39c42de";
  };

  build-system = [ setuptools ];

  meta = {
    description = "Typing stubs for futures";
    homepage = "https://github.com/python/typeshed";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ andersk ];
  };
}
