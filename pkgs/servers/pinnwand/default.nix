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
  version = "1.2.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "supakeen";
    repo = pname;
    rev = "v${version}";
    sha256 = "n5PH21QmU8YAb0WKXAKZR4wjfFTSSOtvlRq7yxRVZNE=";
  };

  patches = [
    # https://github.com/supakeen/pinnwand/issues/93
    ./add-build-backend.patch
  ];

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

