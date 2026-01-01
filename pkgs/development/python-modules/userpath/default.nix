{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  click,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "userpath";
  version = "1.9.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-bFIojasGklfMgxhG0V1IEzUiRV1Gd+5pqXgfEdvv2BU=";
  };

  nativeBuildInputs = [ hatchling ];

  propagatedBuildInputs = [ click ];

  # Test suite is difficult to emulate in sandbox due to shell manipulation
  doCheck = false;

  pythonImportsCheck = [ "userpath" ];

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "Cross-platform tool for adding locations to the user PATH";
    mainProgram = "userpath";
    homepage = "https://github.com/ofek/userpath";
    changelog = "https://github.com/ofek/userpath/releases/tag/v${version}";
<<<<<<< HEAD
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ yshym ];
=======
    license = with licenses; [
      asl20
      mit
    ];
    maintainers = with maintainers; [ yshym ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
