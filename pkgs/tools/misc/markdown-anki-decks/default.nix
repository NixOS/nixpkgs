{ lib
, python3
<<<<<<< HEAD
, fetchPypi
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

python3.pkgs.buildPythonApplication rec {
  pname = "markdown-anki-decks";
  version = "1.1.1";
  format = "pyproject";

<<<<<<< HEAD
  src = fetchPypi {
=======
  src = python3.pkgs.fetchPypi {
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    maintainers = with maintainers; [ ];
=======
    maintainers = with maintainers; [ jtojnar ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    platforms = platforms.unix;
  };
}
