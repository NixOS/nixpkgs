{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  dek,
  xmod,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "tdir";
  version = "1.8.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rec";
    repo = "tdir";
    rev = "v${version}";
    hash = "sha256-YYQ33Blhqk/CbocqkB9Nh6qbzMjQT07fmzx+fDTvdw8=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    dek
    xmod
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "tdir" ];

<<<<<<< HEAD
  meta = {
    description = "Create, fill a temporary directory";
    homepage = "https://github.com/rec/tdir";
    changelog = "https://github.com/rec/tdir/blob/${src.rev}/CHANGELOG";
    license = lib.licenses.mit;
=======
  meta = with lib; {
    description = "Create, fill a temporary directory";
    homepage = "https://github.com/rec/tdir";
    changelog = "https://github.com/rec/tdir/blob/${src.rev}/CHANGELOG";
    license = licenses.mit;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
  };
}
