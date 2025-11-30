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
  version = "0.17.5";
  pyproject = true;

  outputs = [
    "out"
    "doc"
  ];

  src = fetchFromGitHub {
    owner = "felix-hilden";
    repo = "sphinx-codeautolink";
    tag = "v${version}";
    hash = "sha256-43XDCajH+uSHnofjK/gH4EAiv2ljjuBr8UbJtm/DsDI=";
  };

  build-system = [ setuptools ];

  nativeBuildInputs = [
    sphinxHook
    sphinx-rtd-theme
    matplotlib
    ipython
  ];

  sphinxRoot = "docs/src";

  dependencies = [
    sphinx
    beautifulsoup4
  ];

  nativeCheckInputs = [ pytest ];

  pythonImportsCheck = [ "sphinx_codeautolink" ];

  meta = with lib; {
    description = "Sphinx extension that makes code examples clickable";
    homepage = "https://github.com/felix-hilden/sphinx-codeautolink";
    changelog = "https://github.com/felix-hilden/sphinx-codeautolink/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ kaction ];
  };
}
