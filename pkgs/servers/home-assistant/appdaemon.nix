{ lib, python3, fetchpatch }:

let
  python = python3.override {
    packageOverrides = self: super: {

      aiohttp = super.aiohttp.overridePythonAttrs (oldAttrs: rec {
        version = "2.3.10";
        src = oldAttrs.src.override {
          inherit version;
          sha256 = "8adda6583ba438a4c70693374e10b60168663ffa6564c5c75d3c7a9055290964";
        };
      });

      yarl = super.yarl.overridePythonAttrs (oldAttrs: rec {
        version = "1.1.0";
        src = oldAttrs.src.override {
          inherit version;
          sha256 = "6af895b45bd49254cc309ac0fe6e1595636a024953d710e01114257736184698";
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
  version = "3.0.0b4";

  src = python.pkgs.fetchPypi {
    inherit pname version;
    sha256 = "0dfc37ecd8e1344001d4970d32813c581aba1385cf3b82c69f8b7df2eca6c019";
  };

  patches = fetchpatch {
    url = "${meta.homepage}/pull/252.patch";
    sha256 = "164qvgdibd2645yxm4n16bhnan13wrchfi70jp2ff806fwdg9mg0";
  };

  propagatedBuildInputs = with python.pkgs; [
    aiohttp aiohttp-jinja2 astral bcrypt daemonize feedparser iso8601
    jinja2 pyyaml requests sseclient voluptuous websocket_client yarl
  ];

  # no tests implemented
  doCheck = false;

  meta = with lib; {
    description = "Sandboxed python execution environment for writing automation apps for Home Assistant";
    homepage = https://github.com/home-assistant/appdaemon;
    license = licenses.mit;
    maintainers = with maintainers; [ peterhoeg dotlambda ];
  };
}
