{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  accelerate,
  fastmcp,
  flask,
  magika,
  mcp,
  numpy,
  pydantic,
  requests,
  torch,
  tqdm,
  transformers,
  tree-sitter,
  tree-sitter-markdown,

  cudaSupport ? torch.cudaSupport,
}:

buildPythonPackage (finalAttrs: {
  pname = "sembr";
  version = "0.2.3-unstable-2025-08-03"; # no tagged release upstream yet
  pyproject = true;

  src = fetchFromGitHub {
    owner = "admk";
    repo = "sembr";
    rev = "8cd0e83615b6b94fd09aa67d191cf4c07466c41a";
    hash = "sha256-mnigzatTsYpub3paizkKp9PmIpKm/F2owQBFzkiJM+8=";
  };

  postPatch = ''
    # Fix setuptools package discovery to include processors subpackage
    substituteInPlace pyproject.toml \
      --replace-fail 'include = ["sembr"]' 'include = ["sembr", "sembr.*"]'
  '';

  build-system = [
    setuptools
  ];

  dependencies = [
    accelerate
    fastmcp
    flask
    magika
  ]
  ++ mcp.optional-dependencies.cli
  ++ [
    numpy
    pydantic
    requests
    torch
    tqdm
    transformers
    tree-sitter
    tree-sitter-markdown
  ];

  pythonImportsCheck = [
    "sembr"
    "sembr.processors"
  ];

  passthru = {
    inherit cudaSupport;
  };

  meta = {
    description = "Semantic line breaker powered by transformers";
    homepage = "https://github.com/admk/sembr";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ daniel-fahey ];
    mainProgram = "sembr";
    # thrift tests fail on x86_64-darwin, breaking the transformers dependency chain
    broken = stdenv.hostPlatform.system == "x86_64-darwin";
  };
})
