{ buildPythonApplication, lib, fetchFromGitHub
, argcomplete, arxiv2bib, beautifulsoup4, bibtexparser
, configparser, dmenu-python, habanero, papis-python-rofi
, pylibgen, prompt_toolkit, pyparser, pytest, python_magic
, pyyaml, requests, unidecode, urwid, vobject, tkinter
, vim
}:

buildPythonApplication rec {
  pname = "papis";
  version = "0.5.3";

  # Missing tests on Pypi
  src = fetchFromGitHub {
    owner = "alejandrogallo";
    repo = pname;
    rev = "v${version}";
    sha256 = "1yc4ilb7bw099pi2vwawyf8mi0n1kp87wgwgwcwc841ibq62q8ic";
  };

  postPatch = "sed -i 's/configparser>=3.0.0/# configparser>=3.0.0/' setup.py";

  propagatedBuildInputs = [
    argcomplete arxiv2bib beautifulsoup4 bibtexparser
    configparser dmenu-python habanero papis-python-rofi
    pylibgen prompt_toolkit pyparser python_magic pyyaml
    requests unidecode urwid vobject tkinter
    vim
  ];

  checkInputs = [ pytest ];

  # Papis tries to create the config folder under $HOME during the tests
  checkPhase = ''
    mkdir -p check-phase
    export HOME=$(pwd)/check-phase

    make test
    make test-non-pythonic
  '';

  meta = {
    description = "Powerful command-line document and bibliography manager";
    homepage = http://papis.readthedocs.io/en/latest/;
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.nico202 ];
  };
}
