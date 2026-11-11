{
  lib,
  bottle,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  sphinx,
  uv-build,
}:

buildPythonPackage (finalAttrs: {
  pname = "sphinxcontrib-httpdomain";
  version = "2.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sphinx-contrib";
    repo = "httpdomain";
    tag = finalAttrs.version;
    hash = "sha256-DDG5YQ8hvcAQcztxNIzxszlTESkX656pDbDV6Qss1BQ=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "uv_build >= 0.9.26, <0.10.0" "uv_build"
  '';

  build-system = [ uv-build ];

  buildInputs = [ sphinx ];

  nativeCheckInputs = [
    bottle
    pytestCheckHook
  ];

  pythonNamespaces = [ "sphinxcontrib" ];

  meta = {
    description = "Provides a Sphinx domain for describing RESTful HTTP APIs";
    homepage = "https://github.com/sphinx-contrib/httpdomain";
    changelog = "https://github.com/sphinx-contrib/httpdomain/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd0;
    maintainers = [ ];
  };
})
