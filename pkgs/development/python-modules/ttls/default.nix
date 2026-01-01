{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
<<<<<<< HEAD
  hatchling,
  uv-dynamic-versioning,
=======
  poetry-core,
  pythonOlder,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}:

buildPythonPackage rec {
  pname = "ttls";
<<<<<<< HEAD
  version = "1.10.0";
  pyproject = true;

=======
  version = "1.9.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  src = fetchFromGitHub {
    owner = "jschlyter";
    repo = "ttls";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-ETqjL7pl/FekzMusBtq8jMr72/j7Dy/zadcObSNaKqU=";
  };

  build-system = [
    hatchling
    uv-dynamic-versioning
  ];

  dependencies = [ aiohttp ];
=======
    hash = "sha256-itGXZbQZ+HYpiwySLeGN3mPy3fgsxx0A9byOxIVpRBc=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    aiohttp
  ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "ttls" ];

<<<<<<< HEAD
  meta = {
    description = "Module to interact with Twinkly LEDs";
    homepage = "https://github.com/jschlyter/ttls";
    changelog = "https://github.com/jschlyter/ttls/blob/${src.tag}/CHANGES.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "ttls";
=======
  meta = with lib; {
    description = "Module to interact with Twinkly LEDs";
    mainProgram = "ttls";
    homepage = "https://github.com/jschlyter/ttls";
    changelog = "https://github.com/jschlyter/ttls/blob/v${version}/CHANGES.md";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
