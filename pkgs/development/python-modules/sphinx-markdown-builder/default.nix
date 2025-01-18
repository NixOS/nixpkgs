{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  nix-update-script,

  # build system
  setuptools,
  wheel,

  # deps
  docutils,
  sphinx,
  tabulate,

  # optional deps
  black,
  bumpver,
  coveralls,
  flake8,
  isort,
  pip-tools,
  pylint,
  pytest,
  pytest-cov,
  sphinxcontrib-httpdomain,
  sphinxcontrib-plantuml,
}:

buildPythonPackage rec {
  pname = "sphinx-markdown-builder";
  version = "0.6.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "liran-funaro";
    repo = "sphinx-markdown-builder";
    rev = version;
    hash = "sha256-hrXuLfICiWVmC1HUypfhbW92YRmqzFY8nHVEWhTAJ6c=";
  };

  build-system = [
    setuptools
    wheel
  ];

  dependencies = [
    docutils
    sphinx
    tabulate
  ];

  optional-dependencies = {
    dev = [
      black
      bumpver
      coveralls
      flake8
      isort
      pip-tools
      pylint
      pytest
      pytest-cov
      sphinx
      sphinxcontrib-httpdomain
      sphinxcontrib-plantuml
    ];
  };

  pythonImportsCheck = [
    "sphinx_markdown_builder"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Sphinx extension to add markdown generation support";
    homepage = "https://github.com/liran-funaro/sphinx-markdown-builder";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ eljamm ];
  };
}
