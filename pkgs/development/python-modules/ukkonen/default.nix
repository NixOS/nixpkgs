{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  cffi,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "ukkonen";
  version = "1.1.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "asottile";
    repo = "ukkonen";
    rev = "v${version}";
    sha256 = "sha256-vXyOLAiY92Df7g57quiSnOz8yhaIsm8MTB6Fbiv6axQ=";
  };

  nativeBuildInputs = [ cffi ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "ukkonen" ];

  meta = {
    description = "Python implementation of bounded Levenshtein distance (Ukkonen)";
    homepage = "https://github.com/asottile/ukkonen";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
