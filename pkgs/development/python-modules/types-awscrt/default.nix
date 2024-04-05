{ lib
, buildPythonPackage
, fetchPypi
, poetry-core
, pythonOlder
}:

buildPythonPackage rec {
  pname = "types-awscrt";
  version = "0.20.5";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "types_awscrt";
    inherit version;
    hash = "sha256-YYEbv03pUkiTn5J2pDS+k9K5X2zP6KqU5WmZ6XeM/MI=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  pythonImportsCheck = [
    "awscrt-stubs"
  ];

  meta = with lib; {
    description = "Type annotations and code completion for awscrt";
    homepage = "https://github.com/youtype/types-awscrt";
    changelog = "https://github.com/youtype/types-awscrt/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
