{
  lib,
  fetchFromGitHub,
  gitUpdater,
  buildPythonPackage,
  setuptools,
  beautifulsoup4,
  gitpython,
  pydata-sphinx-theme,
  pygithub,
  sphinx,
  breathe,
  myst-nb,
  myst-parser,
  sphinx-book-theme,
  sphinx-copybutton,
  sphinx-design,
  sphinx-external-toc,
  sphinx-notfound-page,
  pyyaml,
  fastjsonschema,
}:

# FIXME: Move to rocmPackages_common
buildPythonPackage rec {
  pname = "rocm-docs-core";
  version = "1.31.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ROCm";
    repo = "rocm-docs-core";
    rev = "v${version}";
    hash = "sha256-N9wqu83fPQGgOSDdb4yXmfxfDxkevk6QA31vLl5sYHo=";
  };

  buildInputs = [ setuptools ];

  propagatedBuildInputs = [
    beautifulsoup4
    gitpython
    pydata-sphinx-theme
    pygithub
    sphinx
    breathe
    myst-nb
    myst-parser
    sphinx-book-theme
    sphinx-copybutton
    sphinx-design
    sphinx-external-toc
    sphinx-notfound-page
    pyyaml
    fastjsonschema
  ];

  pythonImportsCheck = [ "rocm_docs" ];

  passthru.updateScript = gitUpdater { rev-prefix = "v"; };

  meta = {
    description = "ROCm Documentation Python package for ReadTheDocs build standardization";
    homepage = "https://github.com/ROCm/rocm-docs-core";
    license = with lib.licenses; [
      mit
      cc-by-40
    ];
    teams = [ lib.teams.rocm ];
    platforms = lib.platforms.linux;
  };
}
