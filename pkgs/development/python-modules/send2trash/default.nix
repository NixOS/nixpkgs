{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "send2trash";
  version = "1.8.3";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "hsoft";
    repo = "send2trash";
    tag = version;
    hash = "sha256-3RbKfluKOvl+sGJldtAt2bVfcasVKjCqVxmF6hVwh+Y=";
  };

  nativeBuildInputs = [ setuptools ];

  doCheck = !stdenv.hostPlatform.isDarwin;

  preCheck = ''
    export HOME=$TMPDIR
  '';

  nativeCheckInputs = [ pytestCheckHook ];

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "Send file to trash natively under macOS, Windows and Linux";
    mainProgram = "send2trash";
    homepage = "https://github.com/hsoft/send2trash";
    changelog = "https://github.com/arsenetar/send2trash/blob/${version}/CHANGES.rst";
<<<<<<< HEAD
    license = lib.licenses.bsd3;
=======
    license = licenses.bsd3;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
  };
}
