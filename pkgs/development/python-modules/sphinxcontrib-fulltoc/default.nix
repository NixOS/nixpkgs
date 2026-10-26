{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pbr,
  sphinx,
}:

buildPythonPackage (finalAttrs: {
  pname = "sphinxcontrib-fulltoc";
  version = "1.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sphinx-contrib";
    repo = "fulltoc";
    tag = finalAttrs.version;
    hash = "sha256-rpzKiZgsuAqhLDEYURv77SDJny3eqfj0VtJ1tqT29IQ=";
  };

  env.PBR_VERSION = finalAttrs.version;

  build-system = [ pbr ];

  dependencies = [ sphinx ];

  # Module has no unit tests
  doCheck = false;

  pythonImportsCheck = [ "sphinxcontrib.fulltoc" ];

  pythonNamespaces = [ "sphinxcontrib" ];

  meta = {
    description = "Include a full table of contents in your Sphinx HTML sidebar";
    homepage = "https://sphinxcontrib-fulltoc.readthedocs.org/";
    changelog = "https://github.com/sphinx-contrib/fulltoc/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ jluttine ];
  };
})
