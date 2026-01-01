{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "xmod";
  version = "1.8.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rec";
    repo = "xmod";
    rev = "v${version}";
    hash = "sha256-pfFxtDQ4kaBrx4XzYMQO1vE4dUr2zs8jgGUQUdXB798=";
  };

  build-system = [ poetry-core ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [ "test_partial_function" ];

  pythonImportsCheck = [ "xmod" ];

<<<<<<< HEAD
  meta = {
    description = "Turn any object into a module";
    homepage = "https://github.com/rec/xmod";
    changelog = "https://github.com/rec/xmod/blob/${src.rev}/CHANGELOG";
    license = lib.licenses.mit;
=======
  meta = with lib; {
    description = "Turn any object into a module";
    homepage = "https://github.com/rec/xmod";
    changelog = "https://github.com/rec/xmod/blob/${src.rev}/CHANGELOG";
    license = licenses.mit;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
  };
}
