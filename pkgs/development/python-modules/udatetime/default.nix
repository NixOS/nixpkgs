{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "udatetime";
  version = "0.0.17";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "freach";
    repo = "udatetime";
    tag = finalAttrs.version;
    hash = "sha256-1TGLdw8yq+FmdfKin2e9SKJTA1TDNmLXmKRWcq0qTnw=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  # shadows the installed package holding the compiled extension
  preCheck = ''
    rm -r udatetime
  '';

  pythonImportsCheck = [ "udatetime" ];

  meta = {
    description = "Fast RFC3339 compliant Python date-time library";
    mainProgram = "bench_udatetime.py";
    homepage = "https://github.com/freach/udatetime";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
})
