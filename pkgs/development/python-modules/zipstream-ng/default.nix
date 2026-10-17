{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  hatchling,
}:

buildPythonPackage rec {
  pname = "zipstream-ng";
  version = "1.9.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pR0Ps";
    repo = "zipstream-ng";
    tag = "v${version}";
    hash = "sha256-YVF7uUOCYtQRtOUzS8/l9hIxp1nR0hoEJGpEw7HViwE=";
  };

  build-system = [ hatchling ];

  pythonImportsCheck = [ "zipstream" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Library to generate streamable zip files";
    mainProgram = "zipserver";
    longDescription = ''
      A modern and easy to use streamable zip file generator. It can package and stream many files
      and folders on the fly without needing temporary files or excessive memory
    '';
    homepage = "https://github.com/pR0Ps/zipstream-ng";
    changelog = "https://github.com/pR0Ps/zipstream-ng/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.lgpl3Only;
    maintainers = with lib.maintainers; [ gador ];
  };
}
