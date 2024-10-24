{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pythonOlder,
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "smoke-zephyr";
  version = "2.0.1";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "zeroSteiner";
    repo = "smoke-zephyr";
    rev = "refs/tags/v${version}";
    hash = "sha256-XZj8sxEWYv5z1x7LKb0T3L7MWSZbWr7lAIyjWekN+WY=";
  };

  postPatch = ''
    substituteInPlace tests/utilities.py \
      --replace-fail "assertEquals" "assertEqual"
  '';

  build-system = [ setuptools ];

  nativeCheckInputs = [ unittestCheckHook ];

  pythonImportsCheck = [ "smoke_zephyr" ];

  meta = {
    description = "Python utility collection";
    homepage = "https://github.com/zeroSteiner/smoke-zephyr";
    changelog = "https://github.com/zeroSteiner/smoke-zephyr/releases/tag/v${version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fab ];
  };
}
