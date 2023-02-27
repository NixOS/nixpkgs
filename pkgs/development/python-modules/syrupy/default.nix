{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pytest
, colored
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "syrupy";
  version = "4.0.1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "tophat";
    repo = "syrupy";
    rev = "refs/tags/v${version}";
    hash = "sha256-BL1Z1hPMwU1duAZb3ZTWWKS/XGv8RJ6/4YoBhktd5NE=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  buildInputs = [
    pytest
  ];

  propagatedBuildInputs = [
    colored
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    changelog = "https://github.com/tophat/syrupy/releases/tag/v${version}";
    description = "Pytest Snapshot Test Utility";
    homepage = "https://github.com/tophat/syrupy";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
