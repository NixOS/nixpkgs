{ lib, python3, fetchFromGitHub }:

let
  python = python3.override {
    packageOverrides = self: super: {
      bcrypt = super.bcrypt.overridePythonAttrs (oldAttrs: rec {
        version = "3.1.7";
        src = oldAttrs.src.override {
          inherit version;
          sha256 = "CwBpx1LsFBcsX3ggjxhj161nVab65v527CyA0TvkHkI=";
        };
      });

      yarl = super.yarl.overridePythonAttrs (oldAttrs: rec {
        version = "1.4.2";
        src = oldAttrs.src.override {
          inherit version;
          sha256 = "WM2cRp7O1VjNgao/SEspJOiJcEngaIno/yUQQ1t+90s=";
        };
      });
    };
  };

in python.pkgs.buildPythonApplication rec {
  pname = "appdaemon";
  version = "4.0.5";

  src = fetchFromGitHub {
    owner = "home-assistant";
    repo = "appdaemon";
    rev = version;
    sha256 = "7o6DrTufAC+qK3dDfpkuQMQWuduCZ6Say/knI4Y07QM=";
  };

  propagatedBuildInputs = with python.pkgs; [
    daemonize astral requests websocket_client aiohttp yarl jinja2
    aiohttp-jinja2 pyyaml voluptuous feedparser iso8601 bcrypt paho-mqtt setuptools
    deepdiff dateutil bcrypt python-socketio pid pytz sockjs pygments
    azure-mgmt-compute azure-mgmt-storage azure-mgmt-resource azure-keyvault-secrets azure-storage-blob
  ];

  # no tests implemented
  doCheck = false;

  postPatch = ''
    substituteInPlace requirements.txt \
      --replace "pyyaml==5.3" "pyyaml" \
      --replace "pid==2.2.5" "pid" \
      --replace "Jinja2==2.11.1" "Jinja2" \
      --replace "pytz==2019.3" "pytz" \
      --replace "aiohttp==3.6.2" "aiohttp>=3.6" \
      --replace "iso8601==0.1.12" "iso8601>=0.1" \
      --replace "azure==4.0.0" "azure-mgmt-compute
    azure-mgmt-storage
    azure-mgmt-resource
    azure-keyvault-secrets
    azure-storage-blob" \
      --replace "sockjs==0.10.0" "sockjs" \
      --replace "deepdiff==4.3.1" "deepdiff" \
      --replace "voluptuous==0.11.7" "voluptuous" \
      --replace "astral==1.10.1" "astral" \
      --replace "python-socketio==4.4.0" "python-socketio"
  '';

  meta = with lib; {
    description = "Sandboxed python execution environment for writing automation apps for Home Assistant";
    homepage = "https://github.com/home-assistant/appdaemon";
    license = licenses.mit;
    maintainers = with maintainers; [ peterhoeg dotlambda ];
  };
}
