{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  pytestCheckHook,
  tomli,
}:

buildPythonPackage rec {
  pname = "tomli-w";
  version = "1.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "hukkin";
    repo = "tomli-w";
    rev = version;
    hash = "sha256-Du37ySvAL9iwGec5wbWxwLTYm+kcDSOs5OJ5Sw7R87g=";
  };

  build-system = [ flit-core ];

  nativeCheckInputs = [
    pytestCheckHook
    tomli
  ];

  pythonImportsCheck = [ "tomli_w" ];

  meta = with lib; {
    description = "Write-only counterpart to Tomli, which is a read-only TOML parser";
    homepage = "https://github.com/hukkin/tomli-w";
    changelog = "https://github.com/hukkin/tomli-w/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ lovesegfault ];
  };
}
