{
  buildPythonPackage,
  lib,
  fetchFromGitHub,
  isPy27,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "tokenize-rt";
  version = "6.2.0";
  pyproject = true;

  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "asottile";
    repo = "tokenize-rt";
    tag = "v${version}";
    hash = "sha256-25HeYVS5pN7mBllycumnrEkgP/a1HjrPNgqo6qJOStU=";
  };

  nativeBuildInputs = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Wrapper around the stdlib `tokenize` which roundtrips";
    mainProgram = "tokenize-rt";
    homepage = "https://github.com/asottile/tokenize-rt";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ lovesegfault ];
  };
}
