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
  version = "3.0.6";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "tophat";
    repo = "syrupy";
    rev = "refs/tags/v${version}";
    hash = "sha256-8DdPgah1cWVY9YZT78otlAv7X00iwxfi+Fkn3OmLgeM=";
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
