{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "zhon";
  version = "2.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tsroten";
    repo = "zhon";
    tag = "v${version}";
    hash = "sha256-LFuEXu0IPJ6UFHhJKqQHp829wndNypmmhO0yZ1WEAXg=";
  };

  build-system = [ hatchling ];

  nativeCheckInputs = [ unittestCheckHook ];

  pythonImportsCheck = [ "zhon" ];

  meta = {
    description = "Constants used in Chinese text processing";
    homepage = "https://github.com/tsroten/zhon";
    changelog = "https://github.com/tsroten/zhon/blob/${src.rev}/CHANGES.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ShamrockLee ];
  };
}
