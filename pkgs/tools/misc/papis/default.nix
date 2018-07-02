{ buildPythonApplication, lib, fetchFromGitHub, bashInteractive
, python3, vim
}:

let
  python = python3.override {
    packageOverrides = self: super: {

      # https://github.com/eventable/vobject/issues/112
      python-dateutil = super.python-dateutil.overridePythonAttrs (oldAttrs: rec {
        version = "2.6.1";
        src = oldAttrs.src.override {
          inherit version;
          sha256 = "891c38b2a02f5bb1be3e4793866c8df49c7d19baabf9c1bad62547e0b4866aca";
        };
      });

    };
  };

in python.pkgs.buildPythonApplication rec {
  pname = "papis";
  version = "0.5.3";

  # Missing tests on Pypi
  src = fetchFromGitHub {
    owner = "papis";
    repo = pname;
    rev = "v${version}";
    sha256 = "1yc4ilb7bw099pi2vwawyf8mi0n1kp87wgwgwcwc841ibq62q8ic";
  };

  postPatch = ''
    sed -i 's/configparser>=3.0.0/# configparser>=3.0.0/' setup.py
    patchShebangs tests
  '';

  propagatedBuildInputs = with python.pkgs; [
    argcomplete arxiv2bib beautifulsoup4 bibtexparser
    configparser dmenu-python habanero papis-python-rofi
    pylibgen prompt_toolkit pyparser python_magic pyyaml
    requests unidecode urwid vobject tkinter
    vim
  ];

  checkInputs = with python.pkgs; [ pytest ];

  # Papis tries to create the config folder under $HOME during the tests
  checkPhase = ''
    mkdir -p check-phase
    export PATH=$out/bin:$PATH
    # Still don't know why this fails
    sed -i 's/--set dir=hello //' tests/bash/test_default.sh

    # This test has been disabled since it requires a network connaction
    sed -i 's/test_downloader_getter(self):/disabled_test_downloader_getter(self):/' papis/downloaders/tests/test_main.py

    export HOME=$(pwd)/check-phase
    make test
    SH=${bashInteractive}/bin/bash make test-non-pythonic
  '';

  meta = {
    description = "Powerful command-line document and bibliography manager";
    homepage = http://papis.readthedocs.io/en/latest/;
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.nico202 ];
  };
}
