{ lib, python3, fetchFromGitHub, poetry, nixosTests }:

let
  python = python3.override {
    packageOverrides = self: super: {
      tornado = super.tornado.overridePythonAttrs (oldAttrs: rec {
        version = "6.0.4";
        src = oldAttrs.src.override {
          inherit version;
          sha256 = "1p5n7sw4580pkybywg93p8ddqdj9lhhy72rzswfa801vlidx9qhg";
        };
      });
    };
  };
in with python.pkgs; buildPythonApplication rec {
  pname = "pinnwand";
  version = "1.2.1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "supakeen";
    repo = pname;
    rev = "v${version}";
    sha256 = "1rk7rpyb4vmqxqqv8k9jpjmgakr3mn1iaqxyj34r74p1n5vfzimq";
  };

  nativeBuildInputs = [
    poetry
  ];

  propagatedBuildInputs = [
    click
    docutils
    tornado
    pygments-better-html
    toml
    sqlalchemy
  ];

  checkInputs = [ pytest ];

  checkPhase = ''
    pytest
  '';

  passthru.tests = nixosTests.pinnwand;

  meta = with lib; {
    homepage = "https://supakeen.com/project/pinnwand/";
    license = licenses.mit;
    description = "A Python pastebin that tries to keep it simple.";
    maintainers = with maintainers; [ hexa ];
  };
}

