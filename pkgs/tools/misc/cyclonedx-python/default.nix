{ lib
, fetchFromGitHub
, python3
}:

let
  py = python3.override {
    packageOverrides = self: super: {

      # Requires 'cyclonedx-python-lib = ">= 2.0.0, < 4.0.0"'
      cyclonedx-python-lib = super.cyclonedx-python-lib.overridePythonAttrs (oldAttrs: rec {
        version = "3.1.5";
        src = fetchFromGitHub {
          owner = "CycloneDX";
          repo = "cyclonedx-python-lib";
          rev = "refs/tags/v${version}";
          hash = "sha256-4lA8OdmvQD94jTeDf+Iz7ZyEQ9fZzCxnXQG9Ir8FKhk=";
        };
      });
    };
  };
in
with py.pkgs;

python3.pkgs.buildPythonApplication rec {
  pname = "cyclonedx-python";
  version = "3.11.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "CycloneDX";
    repo = "cyclonedx-python";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-jU/0FkQCyph59TnEE+lckJXsU9whfvWp7dkdfzprYw8=";
  };

  nativeBuildInputs = with py.pkgs; [
    poetry-core
    pythonRelaxDepsHook
  ];

  propagatedBuildInputs = with py.pkgs; [
    chardet
    cyclonedx-python-lib
    packageurl-python
    pip-requirements-parser
    setuptools
    toml
  ];

  # The tests want access to the cyclonedx binary
  doCheck = false;

  pythonImportsCheck = [
    "cyclonedx"
  ];

  meta = with lib; {
    description = "Creates CycloneDX Software Bill of Materials (SBOM) from Python projects";
    homepage = "https://github.com/CycloneDX/cyclonedx-python";
    changelog = "https://github.com/CycloneDX/cyclonedx-python/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
    mainProgram = "cyclonedx-py";
  };
}
