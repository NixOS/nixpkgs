{ lib, fetchFromGitHub, fetchpatch, python3

# Look up dependencies of specified components in component-packages.nix
, extraComponents ? []

# Additional packages to add to propagatedBuildInputs
, extraPackages ? ps: []

# Override Python packages using
# self: super: { pkg = super.pkg.overridePythonAttrs (oldAttrs: { ... }); }
# Applied after defaultOverrides
, packageOverrides ? self: super: { }

# Skip pip install of required packages on startup
, skipPip ? true }:

let

  defaultOverrides = [
    # Override the version of some packages pinned in Home Assistant's setup.py
    (mkOverride "aiohttp" "3.4.0"
      "9b15efa7411dcf3b59c1f4766eb16ba1aba4531a33e54d469ee22106eabce460")
    (mkOverride "astral" "1.6.1"
      "ab0c08f2467d35fcaeb7bad15274743d3ac1ad18b5391f64a0058a9cd192d37d")
    (mkOverride "attrs" "18.1.0"
      "e0d0eb91441a3b53dab4d9b743eafc1ac44476296a2053b6ca3af0b139faf87b")
    (mkOverride "bcrypt" "3.1.4"
      "67ed1a374c9155ec0840214ce804616de49c3df9c5bc66740687c1c9b1cd9e8d")
    (mkOverride "pyjwt" "1.6.4"
      "4ee413b357d53fd3fb44704577afac88e72e878716116270d722723d65b42176")
    (mkOverride "cryptography" "2.3.1"
      "8d10113ca826a4c29d5b85b2c4e045ffa8bad74fb525ee0eceb1d38d4c70dfd6")
    (mkOverride "cryptography_vectors" "2.3.1" # required by cryptography==2.3.1
      "bf4d9b61dce69c49e830950aa36fad194706463b0b6dfe81425b9e0bc6644d46")
    (mkOverride "requests" "2.19.1"
      "ec22d826a36ed72a7358ff3fe56cbd4ba69dd7a6718ffd450ff0e9df7a47ce6a")
    (mkOverride "voluptuous" "0.11.5"
      "567a56286ef82a9d7ae0628c5842f65f516abcb496e74f3f59f1d7b28df314ef")

    # used by check_config script
    # can be unpinned once https://github.com/home-assistant/home-assistant/issues/11917 is resolved
    (mkOverride "colorlog" "3.1.4"
      "418db638c9577f37f0fae4914074f395847a728158a011be2a193ac491b9779d")

    # hass-frontend does not exist in python3.pkgs
    (self: super: {
      hass-frontend = self.callPackage ./frontend.nix { };
    })
  ];

  mkOverride = attrname: version: sha256:
    self: super: {
      ${attrname} = super.${attrname}.overridePythonAttrs (oldAttrs: {
        inherit version;
        src = oldAttrs.src.override {
          inherit version sha256;
        };
      });
    };
    
  py = python3.override {
    # Put packageOverrides at the start so they are applied after defaultOverrides
    packageOverrides = lib.foldr lib.composeExtensions (self: super: { }) ([ packageOverrides ] ++ defaultOverrides);
  };

  componentPackages = import ./component-packages.nix;

  availableComponents = builtins.attrNames componentPackages.components;

  getPackages = component: builtins.getAttr component componentPackages.components;

  componentBuildInputs = lib.concatMap (component: getPackages component py.pkgs) extraComponents;

  # Ensure that we are using a consistent package set
  extraBuildInputs = extraPackages py.pkgs;

  # Don't forget to run parse-requirements.py after updating
  hassVersion = "0.77.2";

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
    sha256 = "0lqm8n54cs4ji9bqp1z70qswgqv8n9vl8jbip7c2f3icqx19zg10";
  };

  propagatedBuildInputs = [
    # From setup.py
    aiohttp astral async-timeout attrs bcrypt certifi jinja2 pyjwt cryptography pip pytz pyyaml requests voluptuous
    # From http, frontend, recorder and config.config_entries components and auth.mfa_modules.totp
    sqlalchemy aiohttp-cors hass-frontend voluptuous-serialize pyotp pyqrcode
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
