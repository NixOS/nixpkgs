{ lib
, python3
, fetchPypi
}:

python3.pkgs.buildPythonApplication rec {
  pname = "markdown-anki-decks";
  version = "1.1.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-SvKjjE629OwxWsPo2egGf2K6GzlWAYYStarHhA4Ex0w=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'typer = "^0.4.0"' 'typer = "*"'
  '';

  build-system = with python3.pkgs; [
    poetry-core
  ];

  dependencies = with python3.pkgs; [
    beautifulsoup4
    genanki
    markdown
    python-frontmatter
    typer
  ] ++ typer.optional-dependencies.all;

  # No tests available on Pypi and there is only a failing version assertion test in the repo.
  doCheck = false;

  pythonImportsCheck = [
    "markdown_anki_decks"
  ];

  meta = with lib; {
    description = "Tool to convert Markdown files into Anki Decks";
    homepage = "https://github.com/lukesmurray/markdown-anki-decks";
    changelog = "https://github.com/lukesmurray/markdown-anki-decks/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    platforms = platforms.unix;
    mainProgram = "mdankideck";
  };
}
