{
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  lib,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "wassima";
<<<<<<< HEAD
  version = "2.0.3";
=======
  version = "2.0.2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jawah";
    repo = "wassima";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-tkA6U0SqzivR4tHPu7BKawlqoYfkBFgt5ZcV9kOMKzI=";
=======
    hash = "sha256-Ro0PWNJDjspEtVgA/Gj3UlqbRDCiqrk9nEqx1ljbvRI=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [ hatchling ];

  pythonImportsCheck = [ "wassima" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  # tests connect to the internet
  doCheck = false;

  meta = {
    changelog = "https://github.com/jawah/wassima/blob/${src.tag}/CHANGELOG.md";
    description = "Access your OS root certificates with utmost ease";
    homepage = "https://github.com/jawah/wassima";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
