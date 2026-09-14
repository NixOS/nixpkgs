{
  lib,
  fetchpatch,
  buildPythonPackage,
  click,
  fetchFromGitHub,
  flit-core,
  flit-scm,
  pygments,
  pytest-cov-stub,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "ssdp";
  version = "1.3.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "codingjoe";
    repo = "ssdp";
    tag = finalAttrs.version;
    hash = "sha256-1LO5+lfykaepp+MfS/2mlngobhcV1nZvU19Jb0sbVzk=";
  };

  patches = [
    # Fix CLI test skipping under pytest >= 9.1
    (fetchpatch {
      url = "https://github.com/lukegb/ssdp/commit/e5570a13342a2b7271acae1408b37a49e0729e3c.patch";
      hash = "sha256-RwpsrGRn6rEowwHc39bLO8dVTKJP3d3v7Rr1d8sKYvM=";
    })
  ];

  build-system = [
    flit-core
    flit-scm
  ];

  optional-dependencies = {
    cli = [
      click
      pygments
    ];
    pygments = [ pygments ];
  };

  nativeCheckInputs = [
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "ssdp" ];

  meta = {
    description = "Python asyncio library for Simple Service Discovery Protocol (SSDP)";
    homepage = "https://github.com/codingjoe/ssdp";
    changelog = "https://github.com/codingjoe/ssdp/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "ssdp";
  };
})
