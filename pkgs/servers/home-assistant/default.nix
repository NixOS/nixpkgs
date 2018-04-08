{ lib, fetchFromGitHub, python3
, extraComponents ? []
, extraPackages ? ps: []
, skipPip ? true }:

let

  py = python3.override {
    packageOverrides = self: super: {
      aiohttp = super.aiohttp.overridePythonAttrs (oldAttrs: rec {
        version = "3.0.6";
        src = oldAttrs.src.override {
          inherit version;
          sha256 = "5b588d21b454aaeaf2debf3c4a37f0752fb91a5c15b621deca7e8c49316154fe";
        };
      });
      pytest = super.pytest.overridePythonAttrs (oldAttrs: rec {
        version = "3.3.1";
        src = oldAttrs.src.override {
          inherit version;
          sha256 = "14zbnbn53yvrpv79ch6n02myq9b4winjkaykzi356sfqb7f3d16g";
        };
      });
      voluptuous = super.voluptuous.overridePythonAttrs (oldAttrs: rec {
        version = "0.11.1";
        src = oldAttrs.src.override {
          inherit version;
          sha256 = "af7315c9fa99e0bfd195a21106c82c81619b42f0bd9b6e287b797c6b6b6a9918";
        };
      });
      astral = super.astral.overridePythonAttrs (oldAttrs: rec {
        version = "1.5";
        src = oldAttrs.src.override {
          inherit version;
          sha256 = "527628fbfe90c1596c3950ff84ebd07ecc10c8fb1044c903a0519b5057700cb6";
        };
      });
      async-timeout = super.async-timeout.overridePythonAttrs (oldAttrs: rec {
        version = "2.0.0";
        src = oldAttrs.src.override {
          inherit version;
          sha256 = "c17d8ac2d735d59aa62737d76f2787a6c938f5a944ecf768a8c0ab70b0dea566";
        };
      });
      hass-frontend = super.callPackage ./frontend.nix { };
    };
  };

  componentPackages = import ./component-packages.nix;

  availableComponents = builtins.attrNames componentPackages.components;

  getPackages = component: builtins.getAttr component componentPackages.components;

  componentBuildInputs = map (component: getPackages component py.pkgs) extraComponents;

  # Ensure that we are using a consistent package set
  extraBuildInputs = extraPackages py.pkgs;

  # Don't forget to run parse-requirements.py after updating
  hassVersion = "0.65.5";

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
    sha256 = "1jd44y3f31926g08h2zykp9hnigh6yms38mqn3i5gcl01n1n368k";
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
