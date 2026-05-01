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
buildPythonPackage (finalAttrs: {
  pname = "rocm-docs-core";
  version = "1.33.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ROCm";
    repo = "rocm-docs-core";
    rev = "v${finalAttrs.version}";
    hash = "sha256-eHX5Vz3MmIHi6n90hgBm4Ik+MGhxmniw2Me6pyZVC+k=";
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
})
