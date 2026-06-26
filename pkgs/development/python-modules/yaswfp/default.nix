{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage {
  pname = "yaswfp";
  version = "unstable-20210331";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "facundobatista";
    repo = "yaswfp";
    rev = "2a2cc6ca4c0b4d52bd2e658fb5f80fdc0db4924c";
    hash = "sha256-ST4s1OrInVOF3hGwmRXur2PgAuUuGWFtDp55ChP6rbc=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "yaswfp" ];

  meta = {
    description = "Python SWF Parser";
    mainProgram = "swfparser";
    homepage = "https://github.com/facundobatista/yaswfp";
    license = with lib.licenses; gpl3Only;
    maintainers = with lib.maintainers; [ fab ];
  };
}
