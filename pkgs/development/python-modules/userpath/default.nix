{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  click,
}:

buildPythonPackage (finalAttrs: {
  pname = "userpath";
  version = "1.9.2";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-bFIojasGklfMgxhG0V1IEzUiRV1Gd+5pqXgfEdvv2BU=";
  };

  nativeBuildInputs = [ hatchling ];

  propagatedBuildInputs = [ click ];

  # Test suite is difficult to emulate in sandbox due to shell manipulation
  doCheck = false;

  pythonImportsCheck = [ "userpath" ];

  meta = {
    description = "Cross-platform tool for adding locations to the user PATH";
    mainProgram = "userpath";
    homepage = "https://github.com/ofek/userpath";
    changelog = "https://github.com/ofek/userpath/releases/tag/v${finalAttrs.version}";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ yshym ];
  };
})
