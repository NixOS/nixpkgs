{ buildPythonApplication, lib, fetchFromGitHub
, argcomplete, arxiv2bib, beautifulsoup4, bibtexparser
, configparser, habanero, papis-python-rofi, pylibgen
, prompt_toolkit, pyparser, python_magic, pyyaml
, requests, unidecode, urwid, vobject, tkinter
, vim
}:

buildPythonApplication rec {
  pname = "papis";
  version = "0.5.2";

  # Missing tests on Pypi
  src = fetchFromGitHub {
    owner = "alejandrogallo";
    repo = pname;
    rev = "v${version}";
    sha256 = "0cw6ajdaknijka3j2bkkkn0bcxqifk825kq0a0rdbbmc6661pgxb";
  };

  postPatch = "sed -i 's/configparser>=3.0.0/# configparser>=3.0.0/' setup.py";

  propagatedBuildInputs = [
    argcomplete arxiv2bib beautifulsoup4 bibtexparser
    configparser habanero papis-python-rofi pylibgen
    prompt_toolkit pyparser python_magic pyyaml
    requests unidecode urwid vobject tkinter
    vim
  ];

  # Papis tries to create the config folder under $HOME during the tests
  preCheck = ''
    mkdir -p check-phase
    export HOME=$(pwd)/check-phase
  '';


  meta = {
    description = "Powerful command-line document and bibliography manager";
    homepage = http://papis.readthedocs.io/en/latest/;
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.nico202 ];
  };
}
