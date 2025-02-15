{
  buildPythonPackage,
  lib,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "tokenize-rt";
  version = "6.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "asottile";
    repo = "tokenize-rt";
    rev = "v${version}";
    hash = "sha256-7ykczY73KkqR99tYLL/5bgr9bqU444qHs2ONz+ldVyg=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "tokenize_rt" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Wrapper around the stdlib `tokenize` which roundtrips";
    mainProgram = "tokenize-rt";
    homepage = "https://github.com/asottile/tokenize-rt";
    license = licenses.mit;
    maintainers = with maintainers; [ lovesegfault ];
  };
}
