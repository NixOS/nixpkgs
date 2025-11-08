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
  version = "6.1.0";
  pyproject = true;

  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "asottile";
    repo = "tokenize-rt";
    rev = "v${version}";
    hash = "sha256-7ykczY73KkqR99tYLL/5bgr9bqU444qHs2ONz+ldVyg=";
  };

  nativeBuildInputs = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Wrapper around the stdlib `tokenize` which roundtrips";
    mainProgram = "tokenize-rt";
    homepage = "https://github.com/asottile/tokenize-rt";
    license = licenses.mit;
    maintainers = with maintainers; [ lovesegfault ];
  };
}
