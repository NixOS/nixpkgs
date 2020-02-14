{ lib, python3, fetchFromGitHub }:

let
  python = python3.override {
    packageOverrides = self: super: {
      bcrypt = super.bcrypt.overridePythonAttrs (oldAttrs: rec {
        version = "3.1.4";
        src = oldAttrs.src.override {
          inherit version;
          sha256 = "13cyrnqwkhc70rs6dg65z4yrrr3dc42fhk11804fqmci9hvimvb7";
        };
      });

      yarl = super.yarl.overridePythonAttrs (oldAttrs: rec {
        version = "1.1.0";
        src = oldAttrs.src.override {
          inherit version;
          sha256 = "6af895b45bd49254cc309ac0fe6e1595636a024953d710e01114257736184698";
        };
      });

      jinja2 = super.jinja2.overridePythonAttrs (oldAttrs: rec {
        version = "2.10.1";
        src = oldAttrs.src.override {
          inherit version;
          sha256 = "065c4f02ebe7f7cf559e49ee5a95fb800a9e4528727aec6f24402a5374c65013";
        };
      });

      aiohttp-jinja2 = super.aiohttp-jinja2.overridePythonAttrs (oldAttrs: rec {
        version = "0.15.0";
        src = oldAttrs.src.override {
          inherit version;
          sha256 = "0f390693f46173d8ffb95669acbb0e2a3ec54ecce676703510ad47f1a6d9dc83";
        };
      });
    };
  };

in python.pkgs.buildPythonApplication rec {
  pname = "appdaemon";
  version = "4.0.1";

  src = fetchFromGitHub {
    owner = "home-assistant";
    repo = "appdaemon";
    rev = version;
    sha256 = "13qzjv11b0c7s1c66j70qmc222a78805n10lv2svj9yyk1v4xhjv";
  };

  propagatedBuildInputs = with python.pkgs; [
    daemonize astral requests websocket_client aiohttp yarl jinja2
    aiohttp-jinja2 pyyaml voluptuous feedparser iso8601 bcrypt paho-mqtt setuptools
    deepdiff dateutil bcrypt python-socketio pid
  ];

  # no tests implemented
  doCheck = false;

  postPatch = ''
    substituteInPlace requirements.txt --replace "pyyaml==5.1" "pyyaml"
  '';

  meta = with lib; {
    description = "Sandboxed python execution environment for writing automation apps for Home Assistant";
    homepage = https://github.com/home-assistant/appdaemon;
    license = licenses.mit;
    maintainers = with maintainers; [ peterhoeg dotlambda ];
  };
}
