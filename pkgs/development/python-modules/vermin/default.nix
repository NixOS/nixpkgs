{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "vermin";
  version = "1.9.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "netromdk";
    repo = "vermin";
    tag = "v${finalAttrs.version}";
    hash = "sha256-XOruR+/9Ujoz6Pa7v6ux6aw4+mkNhlY+sldSttxhjeo=";
  };

  build-system = [
    setuptools
  ];

  checkPhase = ''
    runHook preCheck
    python runtests.py
    runHook postCheck
  '';

  meta = {
    changelog = "https://github.com/netromdk/vermin/releases/tag/${finalAttrs.src.tag}";
    description = "Concurrently detect the minimum Python versions needed to run code";
    homepage = "https://github.com/netromdk/vermin";
    license = lib.licenses.mit;
    mainProgram = "vermin";
    maintainers = [ lib.maintainers.fidgetingbits ];
  };
})
