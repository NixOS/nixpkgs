{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
  ziglang,
  pytest-asyncio,
}:

buildPythonPackage (finalAttrs: {
  pname = "scrapli";
  version = "2.0.0-rc.7";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "carlmontanari";
    repo = "scrapli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Yq06QxeFxr1A2cqetmIw/MRVvcwM6h7BBKr4ehzVk9o=";
  };

  preBuild = ''
    substituteInPlace setup.py --replace-fail '"bdist_wheel": LibscrapliBdist,' ""
  '';

  build-system = [ setuptools ];

  dependencies = [ ziglang ];

  pythonImportCheck = "scrapli";

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
  ];

  # TODO investigate
  doCheck = false;

  meta = {
    description = "Fast, flexible, sync/async, Python 3.10+ screen scraping client specifically for network devices";
    homepage = "https://github.com/carlmontanari/scrapli";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ felbinger ];
  };
})
