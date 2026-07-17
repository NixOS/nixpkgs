{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  func-timeout,
  jaraco-itertools,
  setuptools,
  setuptools-scm,
}:

let
  zipp = buildPythonPackage rec {
    pname = "zipp";
    version = "4.0.0";
    pyproject = true;

    src = fetchFromGitHub {
      owner = "jaraco";
      repo = "zipp";
      tag = "v${version}";
      hash = "sha256-JkU35S+BpDvWca1+BP61z3W5oyxf/RI21WXZ9fZ65SQ=";
    };

    postPatch = ''
      # Downloads license text at build time
      sed -i "/coherent\.licensed/d" pyproject.toml
    '';

    build-system = [
      setuptools
      setuptools-scm
    ];

    # Prevent infinite recursion with pytest
    doCheck = false;

    nativeCheckInputs = [
      func-timeout
      jaraco-itertools
    ];

    pythonImportsCheck = [ "zipp" ];

    passthru.tests = {
      check = zipp.overridePythonAttrs (_: {
        doCheck = true;
      });
    };

    meta = {
      description = "Pathlib-compatible object wrapper for zip files";
      homepage = "https://github.com/jaraco/zipp";
      license = lib.licenses.mit;
      maintainers = [ ];
    };
  };
in
zipp
