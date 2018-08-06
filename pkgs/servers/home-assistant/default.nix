{ lib, fetchFromGitHub, fetchpatch, python3

# Look up dependencies of specified components in component-packages.nix
, extraComponents ? []

# Additional packages to add to propagatedBuildInputs
, extraPackages ? ps: []

# Skip pip install of required packages on startup
, skipPip ? true }:

let

  py = python3.override {
    # Override the version of some packages pinned in Home Assistant's setup.py
    packageOverrides = self: super: {
      aiohttp = super.aiohttp.overridePythonAttrs (oldAttrs: rec {
        version = "3.3.2";
        src = oldAttrs.src.override {
          inherit version;
          sha256 = "f20deec7a3fbaec7b5eb7ad99878427ad2ee4cc16a46732b705e8121cbb3cc12";
        };
      });
      requests = super.requests.overridePythonAttrs (oldAttrs: rec {
        version = "2.19.1";
        src = oldAttrs.src.override {
          inherit version;
          sha256 = "ec22d826a36ed72a7358ff3fe56cbd4ba69dd7a6718ffd450ff0e9df7a47ce6a";
        };
      });
      voluptuous = super.voluptuous.overridePythonAttrs (oldAttrs: rec {
        version = "0.11.5";
        src = oldAttrs.src.override {
          inherit version;
          sha256 = "567a56286ef82a9d7ae0628c5842f65f516abcb496e74f3f59f1d7b28df314ef";
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
  hassVersion = "0.75.2";

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
    sha256 = "1ib76wz3f6jfi7a0w2v561g8vf5w4p2b2d79667api6ynvbw2l9d";
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
      tests/components/{group,http,frontend} \
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
