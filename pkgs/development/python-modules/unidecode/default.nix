{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
  nix-update-script,
}:

buildPythonPackage rec {
  pname = "unidecode";
  version = "1.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "avian2";
    repo = "unidecode";
    tag = "unidecode-${version}";
    hash = "sha256-CPogyDw8B1Xd3Bt6W9OaImVt+hFQsir16mnSYk8hFWQ=";
  };

  nativeBuildInputs = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "unidecode" ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "unidecode-(.*)"
    ];
  };

  meta = with lib; {
    description = "ASCII transliterations of Unicode text";
    mainProgram = "unidecode";
    homepage = "https://github.com/avian2/unidecode";
    changelog = "https://github.com/avian2/unidecode/blob/unidecode-${version}/ChangeLog";
    license = licenses.gpl2Plus;
    maintainers = [ ];
  };
}
