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
  version = "1.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "KenKundert";
    repo = "shlib";
    tag = "v${version}";
    hash = "sha256-0BWTaHKGVKYIPQ9ifVWp2VZkSH3Gg/NgP3gPhkmw5S4=";
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
    description = "Shell library";
    homepage = "https://github.com/KenKundert/shlib";
    changelog = "https://github.com/KenKundert/shlib/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ jpetrucciani ];
  };
}
