{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "zhon";
  version = "2.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tsroten";
    repo = "zhon";
    tag = "v${version}";
    hash = "sha256-ghZp+5YXmTWf1EJKvdSlqccnxnaLliYR5HxX5DcWXiw=";
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
