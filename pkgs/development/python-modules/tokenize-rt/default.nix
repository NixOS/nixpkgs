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
  version = "5.2.0";
  pyproject = true;

  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "asottile";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-G4Dn6iZLVOovzfEt9eMzp93mTX+bo0tHI5cCbaJLxBQ=";
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
