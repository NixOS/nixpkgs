{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytest-asyncio,
  pytestCheckHook,
  httpx,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "whodap";
  version = "0.1.16";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pogzyb";
    repo = "whodap";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ybJiAWrAcs/9/8WutqsHvwsiWxR+tJL9wcQRaOiUZNQ=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools==82.0.1" "setuptools" \
      --replace-fail "wheel==0.46.3" "wheel"
  '';

  build-system = [ setuptools ];

  dependencies = [ httpx ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  disabledTestPaths = [
    # Requires network access
    "tests/test_client.py"
  ];

  pythonImportsCheck = [ "whodap" ];

  meta = {
    description = "Python RDAP utility for querying and parsing information about domain names";
    homepage = "https://github.com/pogzyb/whodap";
    changelog = "https://github.com/pogzyb/whodap/releases/tag/v${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
