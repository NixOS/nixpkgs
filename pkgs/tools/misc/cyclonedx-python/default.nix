{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "cyclonedx-python";
  version = "4.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "CycloneDX";
    repo = "cyclonedx-python";
    rev = "refs/tags/v${version}";
    hash = "sha256-+XeMRREDX1+v+qOeYiHh7uhadfueYYOxspLY3q1NL6s=";
  };

  build-system = with python3Packages; [ poetry-core ];

  dependencies = with python3Packages; [
    chardet
    cyclonedx-python-lib
    packageurl-python
    pip-requirements-parser
    packaging
    tomli
  ] ++ cyclonedx-python-lib.optional-dependencies.validation;

  pythonImportsCheck = [ "cyclonedx" ];

  meta = {
    description = "Creates CycloneDX Software Bill of Materials (SBOM) from Python projects";
    homepage = "https://github.com/CycloneDX/cyclonedx-python";
    changelog = "https://github.com/CycloneDX/cyclonedx-python/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ xanderio ];
    mainProgram = "cyclonedx-py";
  };
}
