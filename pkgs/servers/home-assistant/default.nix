{ lib, fetchFromGitHub, python3
, extraComponents ? []
, extraPackages ? ps: []
, skipPip ? true }:

let

  py = python3.override {
    packageOverrides = self: super: {
      aiohttp = super.aiohttp.overridePythonAttrs (oldAttrs: rec {
        version = "3.1.3";
        src = oldAttrs.src.override {
          inherit version;
          sha256 = "9fcef0489e3335b200d31a9c1fb6ba80fdafe14cd82b971168c2f9fa1e4508ad";
        };
      });
      pytest = super.pytest.overridePythonAttrs (oldAttrs: rec {
        version = "3.4.2";
        src = oldAttrs.src.override {
          inherit version;
          sha256 = "117bad36c1a787e1a8a659df35de53ba05f9f3398fb9e4ac17e80ad5903eb8c5";
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
      async-timeout = super.async-timeout.overridePythonAttrs (oldAttrs: rec {
        version = "2.0.1";
        src = oldAttrs.src.override {
          inherit version;
          sha256 = "00cff4d2dce744607335cba84e9929c3165632da2d27970dbc55802a0c7873d0";
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
  hassVersion = "0.69.1";

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
    sha256 = "1y74zq1nah9k6rif8k384ri11h1f23ggr613f7qnn0107b23asr4";
  };

  propagatedBuildInputs = [
    # From setup.py
    requests pyyaml pytz pip jinja2 voluptuous typing aiohttp async-timeout astral certifi attrs
    # From http, frontend and recorder components
    sqlalchemy aiohttp-cors hass-frontend
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
      tests/components/test_{api,configurator,demo,discovery,frontend,init,introduction,logger,script,shell_command,system_log,websocket_api}.py
  '';

  makeWrapperArgs = lib.optional skipPip "--add-flags --skip-pip";

  meta = with lib; {
    homepage = https://home-assistant.io/;
    description = "Open-source home automation platform running on Python 3";
    license = licenses.asl20;
    maintainers = with maintainers; [ f-breidenstein dotlambda ];
  };
}
