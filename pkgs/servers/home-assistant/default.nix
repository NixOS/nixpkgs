{ lib, fetchFromGitHub, python3
, extraComponents ? []
, extraPackages ? ps: []
, skipPip ? true }:

let

  py = python3.override {
    packageOverrides = self: super: {
      requests = super.requests.overridePythonAttrs (oldAttrs: rec {
        version = "2.18.4";
        src = oldAttrs.src.override {
          inherit version;
          sha256 = "0zi3v9nsmv9j27d0c0m1dvqyvaxz53g8m0aa1h3qanxs4irkwi4w";
        };
      });
      urllib3 = super.urllib3.overridePythonAttrs (oldAttrs: rec {
        version = "1.22";
        src = oldAttrs.src.override {
          inherit version;
          sha256 = "0kyvc9zdlxr5r96bng5rhm9a6sfqidrbvvkz64s76qs5267dli6c";
        };
      });
      idna = super.idna.overridePythonAttrs (oldAttrs: rec {
        version = "2.6";
        src = oldAttrs.src.override {
          inherit version;
          sha256 = "13qaab6d0s15gknz8v3zbcfmbj6v86hn9pjxgkdf62ch13imssic";
        };
      });
      voluptuous = super.voluptuous.overridePythonAttrs (oldAttrs: rec {
        version = "0.11.1";
        src = oldAttrs.src.override {
          inherit version;
          sha256 = "af7315c9fa99e0bfd195a21106c82c81619b42f0bd9b6e287b797c6b6b6a9918";
        };
      });
      attrs = super.attrs.overridePythonAttrs (oldAttrs: rec {
        version = "18.1.0";
        src = oldAttrs.src.override {
          inherit version;
          sha256 = "e0d0eb91441a3b53dab4d9b743eafc1ac44476296a2053b6ca3af0b139faf87b";
        };
      });
      astral = super.astral.overridePythonAttrs (oldAttrs: rec {
        version = "1.6.1";
        src = oldAttrs.src.override {
          inherit version;
          sha256 = "ab0c08f2467d35fcaeb7bad15274743d3ac1ad18b5391f64a0058a9cd192d37d";
        };
      });
      # used by check_config script
      # can be unpinned once https://github.com/home-assistant/home-assistant/issues/11917 is resolved
      colorlog = super.colorlog.overridePythonAttrs (oldAttrs: rec {
        version = "3.1.4";
        src = oldAttrs.src.override {
          inherit version;
          sha256 = "418db638c9577f37f0fae4914074f395847a728158a011be2a193ac491b9779d";
        };
      });
      hass-frontend = super.callPackage ./frontend.nix { };
    };
  };

  componentPackages = import ./component-packages.nix;

  availableComponents = builtins.attrNames componentPackages.components;

  getPackages = component: builtins.getAttr component componentPackages.components;

  componentBuildInputs = lib.concatMap (component: getPackages component py.pkgs) extraComponents;

  # Ensure that we are using a consistent package set
  extraBuildInputs = extraPackages py.pkgs;

  # Don't forget to run parse-requirements.py after updating
  hassVersion = "0.72.0";

in with py.pkgs; buildPythonApplication rec {
  pname = "homeassistant";
  version = assert (componentPackages.version == hassVersion); hassVersion;

  disabled = pythonOlder "3.5";

  inherit availableComponents;

  # PyPI tarball is missing tests/ directory
  src = fetchFromGitHub {
    owner = "home-assistant";
    repo = "home-assistant";
    rev = version;
    sha256 = "1jz16ikxdh8bkscjs5pczvjqbfllz8avs11gkw8a97c2lds8la76";
  };

  propagatedBuildInputs = [
    # From setup.py
    requests pyyaml pytz pip jinja2 voluptuous typing aiohttp async-timeout astral certifi attrs
    # From http, frontend, recorder and config.config_entries components
    sqlalchemy aiohttp-cors hass-frontend voluptuous-serialize
  ] ++ componentBuildInputs ++ extraBuildInputs;

  checkInputs = [
    pytest requests-mock pydispatcher pytest-aiohttp
  ];

  checkPhase = ''
    # The components' dependencies are not included, so they cannot be tested
    py.test --ignore tests/components
    # Some basic components should be tested however
    py.test \
      tests/components/{group,http} \
      tests/components/test_{api,configurator,demo,discovery,init,introduction,logger,script,shell_command,system_log,websocket_api}.py
  '';

  makeWrapperArgs = lib.optional skipPip "--add-flags --skip-pip";

  meta = with lib; {
    homepage = https://home-assistant.io/;
    description = "Open-source home automation platform running on Python 3";
    license = licenses.asl20;
    maintainers = with maintainers; [ f-breidenstein dotlambda ];
  };
}
