{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  beautifulsoup4,
  requests,
}:

buildPythonPackage (finalAttrs: {
  pname = "wikipedia";
  version = "1.5.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "goldsmith";
    repo = "wikipedia";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/Wjg5TOdF9aHMq0QcyKWU0mxj5VlEgSRugYRiEmSByM=";
  };

  build-system = [ setuptools ];

  dependencies = [
    beautifulsoup4
    requests
  ];

  # The 'unittestCheckHook' is not set because the unit tests need Internet
  pythonImportsCheck = [ "wikipedia" ];

  meta = {
    description = "Pythonic wrapper for the Wikipedia API";
    homepage = "https://github.com/goldsmith/Wikipedia";
    changelog = "https://github.com/goldsmith/Wikipedia/blob/master/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      natsukium
      theobori
    ];
  };
})
