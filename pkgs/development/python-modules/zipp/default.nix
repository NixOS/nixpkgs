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
    version = "3.23.0";
    pyproject = true;

    src = fetchFromGitHub {
      owner = "jaraco";
      repo = "zipp";
      tag = "v${version}";
      hash = "sha256-iao7Aco1Ktvyt1uQCD/le4tAdyVpxfKPi3TRT12YHuU=";
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

    meta = with lib; {
      description = "Pathlib-compatible object wrapper for zip files";
      homepage = "https://github.com/jaraco/zipp";
      license = licenses.mit;
      maintainers = [ ];
    };
  };
in
zipp
