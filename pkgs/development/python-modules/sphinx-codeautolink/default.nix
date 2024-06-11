{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  # documentation build dependencies
  sphinxHook,
  sphinx-rtd-theme,
  matplotlib,
  ipython,
  # runtime dependencies
  sphinx,
  beautifulsoup4,
  # check dependencies
  pytest,
}:

buildPythonPackage rec {
  pname = "sphinx-codeautolink";
  version = "0.15.1";
  format = "pyproject";

  outputs = [
    "out"
    "doc"
  ];

  src = fetchFromGitHub {
    owner = "felix-hilden";
    repo = "sphinx-codeautolink";
    rev = "refs/tags/v${version}";
    hash = "sha256-BnGcLAM/KK8Ub+GmRY1oatUCyP4hvY2O1WTjLHBebpw=";
  };

  nativeBuildInputs = [
    setuptools
    sphinxHook
    sphinx-rtd-theme
    matplotlib
    ipython
  ];

  sphinxRoot = "docs/src";

  propagatedBuildInputs = [
    sphinx
    beautifulsoup4
  ];

  nativeCheckInputs = [ pytest ];

  pythonImportsCheck = [ "sphinx_codeautolink" ];

  meta = with lib; {
    description = "Sphinx extension that makes code examples clickable";
    homepage = "https://github.com/felix-hilden/sphinx-codeautolink";
    license = licenses.mit;
    maintainers = with maintainers; [ kaction ];
  };
}
