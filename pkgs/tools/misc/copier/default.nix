{
  lib,
  git,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "copier";
  version = "9.1.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "copier-org";
    repo = "copier";
    rev = "v${version}";
    # Conflict on APFS on darwin
    postFetch = ''
      rm $out/tests/demo/doc/ma*ana.txt
    '';
    hash = "sha256-x5r7Xv4lAOMkR+UIEeSY7LvbYMLpTWYuICYe9ygz1tA=";
  };

  POETRY_DYNAMIC_VERSIONING_BYPASS = version;

  nativeBuildInputs = [
    python3.pkgs.poetry-core
    python3.pkgs.poetry-dynamic-versioning
  ];

  propagatedBuildInputs = with python3.pkgs; [
    colorama
    decorator
    dunamai
    funcy
    iteration-utilities
    jinja2
    jinja2-ansible-filters
    mkdocs-material
    mkdocs-mermaid2-plugin
    mkdocstrings
    packaging
    pathspec
    plumbum
    pydantic
    pygments
    pyyaml
    pyyaml-include
    questionary
  ];

  makeWrapperArgs = [
    "--suffix PATH : ${lib.makeBinPath [ git ]}"
  ];

  meta = with lib; {
    description = "Library and command-line utility for rendering projects templates";
    homepage = "https://copier.readthedocs.io";
    license = licenses.mit;
    maintainers = with maintainers; [ greg ];
    mainProgram = "copier";
  };
}
