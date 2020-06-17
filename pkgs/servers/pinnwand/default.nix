{ lib, python3, fetchFromGitHub }:

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
  version = "1.1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0iincxkfyyx85ggx9ilms2f8aq4lcbg3rkqgrr4wlsflzhljqd0p";
  };

  propagatedBuildInputs = [
    click
    docutils
    tornado
    pygments-better-html
    toml
    sqlalchemy
  ];

  # tests are only available when fetching from GitHub, where they in turn don't have a setup.py :(
  checkPhase = ''
    $out/bin/pinnwand --help > /dev/null
  '';

  meta = with lib; {
    homepage = "https://supakeen.com/project/pinnwand/";
    license = licenses.mit;
    description = "A Python pastebin that tries to keep it simple.";
    maintainers = with maintainers; [ hexa ];
  };
}

