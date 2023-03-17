{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, poetry-core
, setuptools
, cyclonedx-python-lib
, packageurl-python
, importlib-metadata
, pip-requirements-parser
, toml
}:
 buildPythonPackage rec {
  pname = "cyclonedx-python";
  version = "3.11.0";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "CycloneDX";
    repo = "cyclonedx-python";
    rev = "v${version}";
    sha256 = "sha256-uYXkS4aGCJDjUrUrF/koBc4rA8H4tJQzC8COt9AD+b0=";
  };

  nativeBuildInputs = [poetry-core];

  propagatedBuildInputs = [
    cyclonedx-python-lib
    packageurl-python
    importlib-metadata
    pip-requirements-parser
    setuptools
    toml
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
    maintainers = teams.determinatesystems.members ++ [ maintainers.georgesalkhouri ];
  };
}
