{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "kb";
  version = "0.1.7";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "gnebbia";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-K8EAqZbl2e0h03fFwaKIclZTZARDQp1tRo44znxwW0I=";
  };

  postPatch = ''
    # `attr` module is not available. And `attrs` defines another `attr` package
    # that shadows it.
    substituteInPlace setup.py \
      --replace \
        "install_requires=[\"colored\",\"toml\",\"attr\",\"attrs\",\"gitpython\"]," \
        "install_requires=[\"colored\",\"toml\",\"attrs\",\"gitpython\"],"

    # pytest coverage reporting isn't necessary
    substituteInPlace setup.cfg \
      --replace \
      "addopts = --cov=kb --cov-report term-missing" ""
  '';

  propagatedBuildInputs = with python3.pkgs; [
    colored
    toml
    attrs
    gitpython
  ];

  nativeCheckInputs = with python3.pkgs; [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Minimalist command line knowledge base manager";
    longDescription = ''
      kb is a text-oriented minimalist command line knowledge base manager. kb
      can be considered a quick note collection and access tool oriented toward
      software developers, penetration testers, hackers, students or whoever has
      to collect and organize notes in a clean way. Although kb is mainly
      targeted on text-based note collection, it supports non-text files as well
      (e.g., images, pdf, videos and others).
    '';
    homepage = "https://github.com/gnebbia/kb";
    changelog = "https://github.com/gnebbia/kb/blob/v${version}/CHANGELOG.md";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ wesleyjrz ];
    mainProgram = "kb";
  };
}
