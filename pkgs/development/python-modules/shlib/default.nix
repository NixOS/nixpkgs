{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  pytestCheckHook,
  braceexpand,
  inform,
}:

buildPythonPackage rec {
  pname = "shlib";
  version = "1.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "KenKundert";
    repo = "shlib";
    tag = "v${version}";
    hash = "sha256-clhiTuU5vvZSzdGPA3CISiBTnAahvv1SOKAfMpb6lYU=";
  };

  postPatch = ''
    patchShebangs .
  '';

  build-system = [ flit-core ];

  dependencies = [
    braceexpand
    inform
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "shlib" ];

  meta = with lib; {
    description = "shell library";
    homepage = "https://github.com/KenKundert/shlib";
    changelog = "https://github.com/KenKundert/shlib/releases/tag/${src.tag}";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ jpetrucciani ];
  };
}
