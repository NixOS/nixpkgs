{ lib
, python3
, fetchPypi
}:

python3.pkgs.buildPythonApplication rec {
  pname = "markdown-anki-decks";
  version = "1.1.1";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-SvKjjE629OwxWsPo2egGf2K6GzlWAYYStarHhA4Ex0w=";
  };

  nativeBuildInputs = with python3.pkgs; [
    poetry-core
  ];

  propagatedBuildInputs = with python3.pkgs; [
    beautifulsoup4
    genanki
    markdown
    python-frontmatter
    typer
  ] ++ typer.optional-dependencies.all;

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'typer = "^0.4.0"' 'typer = "*"'
  '';

  # No tests available on Pypi and there is only a failing version assertion test in the repo.
  doCheck = false;

  pythonImportsCheck = [
    "markdown_anki_decks"
  ];

  meta = with lib; {
    description = "Tool to convert Markdown files into Anki Decks";
    homepage = "https://github.com/lukesmurray/markdown-anki-decks";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    platforms = platforms.unix;
    mainProgram = "mdankideck";
  };
}
