{ lib
, python3
, fetchFromGitHub
}:
python3.pkgs.buildPythonApplication rec {
  pname = "cyclonedx-python";
  version = "0.4.3";

  src = fetchFromGitHub {
    owner = "CycloneDX";
    repo = "cyclonedx-python";
    rev = "v${version}";
    sha256 = "BvG4aWBMsllW2L4lLsiRFUCPjgoDpHxN49fsUFdg7tQ=";
  };

  # They pin versions for exact version numbers because "A bill-of-material such
  # as CycloneDX expects exact version numbers" -- but that's unnecessary with
  # Nix.
  preBuild = ''
    sed "s@==.*'@'@" -i setup.py
  '';

  propagatedBuildInputs = with python3.pkgs; [
    packageurl-python
    requests
    xmlschema
    setuptools
    requirements-parser
    packaging
    chardet
    jsonschema
  ];

  # the tests want access to the cyclonedx binary
  doCheck = false;

  pythonImportsCheck = [
    "cyclonedx"
  ];

  meta = with lib; {
    description = "Creates CycloneDX Software Bill of Materials (SBOM) from Python projects";
    homepage = "https://github.com/CycloneDX/cyclonedx-python";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
