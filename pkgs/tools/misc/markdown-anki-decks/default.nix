{ lib
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "markdown-anki-decks";
  version = "1.0.0";

  format = "pyproject";

  src = python3.pkgs.fetchPypi {
    inherit pname version;
    sha256 = "R6T8KOHMb1Neg/RG5JQl9+7LxOkAoZL0L5wvVaqm9O0=";
  };

  nativeBuildInputs = with python3.pkgs; [
    poetry-core
  ];

  propagatedBuildInputs = with python3.pkgs; [
    genanki
    typer
    colorama
    shellingham
    beautifulsoup4
    markdown
    python-frontmatter
  ];

  postPatch = ''
    # No API changes.
    substituteInPlace pyproject.toml \
      --replace 'python-frontmatter = "^0.5.0"' 'python-frontmatter = "^1.0.0"' \
      --replace 'genanki = "^0.10.1"' 'genanki = "*"' \
      --replace 'typer = "^0.3.2"' 'typer = "^0.4.0"'
  '';

  # No tests available on Pypi and there is only a failing version assertion test in the repo.
  doCheck = false;

  meta = with lib; {
    description = "Simple program to convert markdown files into anki decks";
    maintainers = with maintainers; [ jtojnar ];
    homepage = "https://github.com/lukesmurray/markdown-anki-decks";
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
