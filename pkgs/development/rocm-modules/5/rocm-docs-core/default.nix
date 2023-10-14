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

buildPythonPackage rec {
  pname = "rocm-docs-core";
  version = "0.25.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "RadeonOpenCompute";
    repo = "rocm-docs-core";
    rev = "v${version}";
    hash = "sha256-kOsoIK0vaPT60hGr960s5vc0eloSr5CECtd8Dy24YuM=";
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
    homepage = "https://github.com/RadeonOpenCompute/rocm-docs-core";
    license = with licenses; [ mit cc-by-40 ];
    maintainers = teams.rocm.members;
    platforms = platforms.linux;
  };
}
