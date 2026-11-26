{
  lib,
  aiohttp,
  beautifulsoup4,
  buildPythonPackage,
  fetchFromGitHub,
  orjson,
  pycryptodome,
  pytest-cov-stub,
  pytestCheckHook,
  segno,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "aiovodafone";
  version = "3.3.14";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "chemelli74";
    repo = "aiovodafone";
    tag = "v${finalAttrs.version}";
    hash = "sha256-pzEqiQvc3B4izPRbssEJoo3Kuwp7RSy2fOSP13l1xIw=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools>=84.2.1" "setuptools"
  '';

  # all deps are needlessly pinned to very recent versions
  pythonRelaxDeps = true;

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    beautifulsoup4
    orjson
    pycryptodome
    segno
  ];

  nativeCheckInputs = [
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "aiovodafone" ];

  meta = {
    description = "Library to control Vodafon Station";
    homepage = "https://github.com/chemelli74/aiovodafone";
    changelog = "https://github.com/chemelli74/aiovodafone/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
