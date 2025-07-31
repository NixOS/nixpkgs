{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,

  setuptools,
}:

buildPythonPackage {
  pname = "zalgolib";
  # no tags on github but tagged 0.2.2 on pypi
  version = "0.2.2-unstable-2023-12-13";
  disabled = pythonOlder "3.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jivanyatra";
    repo = "zalgolib";
    rev = "9dbcc78cdb6612e8ff0664b4024fe28f15874b3a";
    hash = "sha256-9hSHvFqPIQcUgxxddVnv7tEltvrxatAb6eLxt1NeBxg=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "zalgolib" ];

  # no tests

  meta = {
    description = "Tools for working with Zalgo-style text";
    homepage = "https://github.com/jivanyatra/zalgolib/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      jk
    ];
  };
}
