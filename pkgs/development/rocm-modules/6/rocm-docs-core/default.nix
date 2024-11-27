{ lib
, stdenv
, fetchFromGitHub
, gitUpdater
, buildPythonPackage
, setuptools
, beautifulsoup4
, gitpython
, pydata-sphinx-theme
, pygithub
, sphinx
, breathe
, myst-parser
, sphinx-book-theme
, sphinx-copybutton
, sphinx-design
, sphinx-external-toc
, sphinx-notfound-page
, pyyaml
, fastjsonschema
}:

# FIXME: Move to rocmPackages_common
buildPythonPackage rec {
  pname = "rocm-docs-core";
  version = "1.8.2";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "ROCm";
    repo = "rocm-docs-core";
    rev = "v${version}";
    hash = "sha256-BB3jXs6tf9PKGOl/hDnTR5jm6+TTWUp1GXbmDVelVfU=";
  };

  buildInputs = [ setuptools ];

  propagatedBuildInputs = [
    beautifulsoup4
    gitpython
    pydata-sphinx-theme
    pygithub
    sphinx
    breathe
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

  meta = with lib; {
    description = "ROCm Documentation Python package for ReadTheDocs build standardization";
    homepage = "https://github.com/ROCm/rocm-docs-core";
    license = with licenses; [ mit cc-by-40 ];
    maintainers = teams.rocm.members;
    platforms = platforms.linux;
  };
}
