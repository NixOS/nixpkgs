{ lib
, buildPythonPackage
, fetchPypi
, poetry-core
, pythonOlder
}:

buildPythonPackage rec {
  pname = "types-awscrt";
  version = "0.19.18";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "types_awscrt";
    inherit version;
    hash = "sha256-T1pZyHwFgraev5lNYU4Pt2zC0KXsPzLk0dscCRhnzdM=";
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
