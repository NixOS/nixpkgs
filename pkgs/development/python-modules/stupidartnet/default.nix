{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "stupidartnet";
  version = "1.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cpvalente";
    repo = "stupidArtnet";
    tag = version;
    hash = "sha256-prLIQn1vFp0Q8FR2WBaU1tr6eKJpEY1ul4ldd4c35ls=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "stupidArtnet" ];

  meta = {
    description = "Library implementation of the Art-Net protocol";
    homepage = "https://github.com/cpvalente/stupidArtnet";
    changelog = "https://github.com/cpvalente/stupidArtnet/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
