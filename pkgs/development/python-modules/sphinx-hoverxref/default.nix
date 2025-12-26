{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  # documentation build dependencies
  sphinxHook,
  sphinx-notfound-page,
  sphinx-prompt,
  sphinx-rtd-theme,
  sphinx-tabs,
  sphinx-version-warning,
  sphinx-autoapi,
  sphinxcontrib-bibtex,
  sphinxemoji,
  # runtime dependencies
  sphinx,
  sphinxcontrib-jquery,
}:

buildPythonPackage rec {
  pname = "sphinx-hoverxref";
  version = "1.5.0";
  pyproject = true;

  outputs = [
    "out"
    "doc"
  ];

  src = fetchFromGitHub {
    owner = "readthedocs";
    repo = "sphinx-hoverxref";
    rev = version;
    hash = "sha256-JHNJGUkO/HXnnnROYBd1pAcoAEYo6b7eK4tyC+ujc+A=";
  };

  postPatch = ''
    substituteInPlace docs/conf.py --replace-fail "sphinx-prompt" "sphinx_prompt"
  '';

  build-system = [
    flit-core
  ];

  nativeBuildInputs = [
    sphinxHook
    sphinx-autoapi
    sphinx-rtd-theme
    sphinx-tabs
    sphinx-prompt
    sphinx-version-warning
    sphinx-notfound-page
    sphinxcontrib-bibtex
    sphinxemoji
  ];

  dependencies = [
    sphinx
    sphinxcontrib-jquery
  ];

  pythonImportsCheck = [ "hoverxref" ];

  meta = {
    description = "Sphinx extension for creating tooltips on the cross references of the documentation";
    longDescription = ''
      sphinx-hoverxref is a Sphinx extension to show a floating window
      (tooltips or modal dialogues) on the cross references of the
      documentation embedding the content of the linked section on them.

      With sphinx-hoverxref, you don’t need to click a link to see what’s
      in there.
    '';
    homepage = "https://github.com/readthedocs/sphinx-hoverxref";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kaction ];
  };
}
