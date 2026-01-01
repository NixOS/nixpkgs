{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
  numpy,
}:

buildPythonPackage rec {
  pname = "sipyco";
  version = "1.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "m-labs";
    repo = "sipyco";
    tag = "v${version}";
    hash = "sha256-PPnAyDedUQ7Og/Cby9x5OT9wMkNGTP8GS53V6N/dk4w=";
  };

  build-system = [ setuptools ];

  dependencies = [ numpy ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "sipyco" ];

  __darwinAllowLocalNetworking = true;

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "Simple Python Communications - used by the ARTIQ experimental control package";
    mainProgram = "sipyco_rpctool";
    homepage = "https://github.com/m-labs/sipyco";
    changelog = "https://github.com/m-labs/sipyco/releases/tag/v${version}";
<<<<<<< HEAD
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ charlesbaynham ];
=======
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ charlesbaynham ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
