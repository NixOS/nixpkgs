{
  lib,
  buildPythonPackage,
  setuptools,
  fetchFromGitHub,
  pytestCheckHook,
}:
buildPythonPackage {
  pname = "warc3-wet-clueweb";
  version = "2.5-unstable-2020-12-07";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "gurjaka";
    repo = "warc3-clueweb";
    rev = "c9ccfe1b312924abee118528782fe11ea7a0701c";
    hash = "sha256-UH9CUPb3vNWC+wJSA1+aCnG113y0yu/ZISHMgllk0Es=";
  };

  build-system = [
    setuptools
  ];

  pythonImportsCheck = [
    "warc3_wet_clueweb09"
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Python 3 library for reading and writing warc files";
    homepage = "https://github.com/seanmacavaney/warc3-clueweb";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ gurjaka ];
  };
}
