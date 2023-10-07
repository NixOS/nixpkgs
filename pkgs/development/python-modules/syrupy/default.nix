{ lib
, buildPythonPackage
, fetchFromGitHub
, python
, poetry-core
, pytest
, colored
, invoke
}:

buildPythonPackage rec {
  pname = "syrupy";
  version = "4.5.0";
  format = "pyproject";

  disabled = lib.versionOlder python.version "3.8.1";

  src = fetchFromGitHub {
    owner = "tophat";
    repo = "syrupy";
    rev = "refs/tags/v${version}";
    hash = "sha256-HRCURqnFzo1l+PjX1LtXTSVZGA36OaRgmy4xKizeuOg=";
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
