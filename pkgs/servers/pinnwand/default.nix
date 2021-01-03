{ lib, python3, fetchFromGitHub, nixosTests, fetchpatch }:

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
  version = "1.2.2";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "supakeen";
    repo = pname;
    rev = "v${version}";
    sha256 = "0cxdpc3lxgzakzgvdyyrn234380dm05svnwr8av5nrjp4nm9s8z4";
  };

  nativeBuildInputs = [
    poetry-core
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

  patches = [
    # Use poetry-core instead of poetry. Fixed in 1.2.3
    (fetchpatch {
      url = "https://github.com/supakeen/pinnwand/commit/38ff5729c59abb97e4b416d3ca66466528b0eac7.patch";
      sha256 = "F3cZe29z/7glmS3KWzcfmZnhYmC0LrLLS0zHk7WS2rQ=";
    })
  ];

  passthru.tests = nixosTests.pinnwand;

  meta = with lib; {
    homepage = "https://supakeen.com/project/pinnwand/";
    license = licenses.mit;
    description = "A Python pastebin that tries to keep it simple";
    maintainers = with maintainers; [ hexa ];
  };
}

