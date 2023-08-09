{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, poetry-core
, pytest
, colored
, invoke
}:

buildPythonPackage rec {
  pname = "syrupy";
  version = "4.0.8";
  format = "pyproject";

  disabled = pythonOlder "3.8.1";

  src = fetchFromGitHub {
    owner = "tophat";
    repo = "syrupy";
    rev = "refs/tags/v${version}";
    hash = "sha256-qUKOZHkpQmeS/QELRf1FoUniaHs/gYyOtsBCFOidx4g=";
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
    invoke
    pytest
  ];

  checkPhase = ''
    runHook preCheck
    # https://github.com/tophat/syrupy/blob/main/CONTRIBUTING.md#local-development
    invoke test
    runHook postCheck
  '';

  pythonImportsCheck = [ "syrupy" ];

  meta = with lib; {
    changelog = "https://github.com/tophat/syrupy/releases/tag/v${version}";
    description = "Pytest Snapshot Test Utility";
    homepage = "https://github.com/tophat/syrupy";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
