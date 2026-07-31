{
  buildPythonPackage,
  fetchPypi,
  lib,
  setuptools,
}:

buildPythonPackage rec {
  pname = "stringcase";
  version = "1.2.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    sha256 = "023hv3gknblhf9lx5kmkcchzmbhkdhmsnknkv7lfy20rcs06k828";
  };

  build-system = [ setuptools ];

  # PyPi package does not include tests.
  doCheck = false;

  meta = {
    homepage = "https://github.com/okunishinishi/python-stringcase";
    description = "Convert string cases between camel case, pascal case, snake case etc…";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ alunduil ];
  };
}
