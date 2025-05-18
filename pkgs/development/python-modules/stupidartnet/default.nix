{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "stupidartnet";
  version = "1.6.0";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "cpvalente";
    repo = "stupidArtnet";
    tag = version;
    hash = "sha256-prLIQn1vFp0Q8FR2WBaU1tr6eKJpEY1ul4ldd4c35ls=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "stupidArtnet" ];

  meta = with lib; {
    description = "Library implementation of the Art-Net protocol";
    homepage = "https://github.com/cpvalente/stupidArtnet";
    changelog = "https://github.com/cpvalente/stupidArtnet/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
