{ lib, fetchFromGitHub, fetchpatch, python

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
    (mkOverride "aiohttp" "3.4.4"
      "51afec6ffa50a9da4cdef188971a802beb1ca8e8edb40fa429e5e529db3475fa")
    (mkOverride "astral" "1.7.1"
      "88086fd2006c946567285286464b2da3294a3b0cbba4410b7008ec2458f82a07")
    (mkOverride "async-timeout" "3.0.1"
      "0c3c816a028d47f659d6ff5c745cb2acf1f966da1fe5c19c77a70282b25f4c5f")
    (mkOverride "attrs" "18.2.0"
      "10cbf6e27dbce8c30807caf056c8eb50917e0eaafe86347671b57254006c3e69")
    (mkOverride "bcrypt" "3.1.4"
      "67ed1a374c9155ec0840214ce804616de49c3df9c5bc66740687c1c9b1cd9e8d")
    (mkOverride "pyjwt" "1.6.4"
      "4ee413b357d53fd3fb44704577afac88e72e878716116270d722723d65b42176")
    (mkOverride "cryptography" "2.3.1"
      "8d10113ca826a4c29d5b85b2c4e045ffa8bad74fb525ee0eceb1d38d4c70dfd6")
    (mkOverride "cryptography_vectors" "2.3.1" # required by cryptography==2.3.1
      "bf4d9b61dce69c49e830950aa36fad194706463b0b6dfe81425b9e0bc6644d46")
    (mkOverride "requests" "2.20.0"
      "99dcfdaaeb17caf6e526f32b6a7b780461512ab3f1d992187801694cba42770c")
    (mkOverride "ruamel_yaml" "0.15.72"
      "97652b9e3a76958cf6684d5d963674adf345d8cc192ddd95e2a21b22cda29f40")
    (mkOverride "voluptuous" "0.11.5"
      "567a56286ef82a9d7ae0628c5842f65f516abcb496e74f3f59f1d7b28df314ef")
    (mkOverride "voluptuous-serialize" "2.0.0"
      "44be04d87aec34bd7d31ab539341fadc505205f2299031ed9be985112c21aa41")

    # used by auth.mfa_modules.totp
    (mkOverride "pyotp" "2.2.6"
      "dd9130dd91a0340d89a0f06f887dbd76dd07fb95a8886dc4bc401239f2eebd69")

    # used by check_config script
    # can be unpinned once https://github.com/home-assistant/home-assistant/issues/11917 is resolved
    (mkOverride "colorlog" "3.1.4"
      "418db638c9577f37f0fae4914074f395847a728158a011be2a193ac491b9779d")

    # hass-frontend does not exist in python.pkgs
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
    
  py = python.override {
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
  hassVersion = "0.82.1";

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
    sha256 = "0d53xp5miz1vm1b5qfznzx33qzxcxi65plp412dyk4r1ag7rh38v";
  };

  propagatedBuildInputs = [
    # From setup.py
    aiohttp astral async-timeout attrs bcrypt certifi jinja2 pyjwt cryptography pip pytz pyyaml requests ruamel_yaml voluptuous voluptuous-serialize
    # From http, frontend and recorder components and auth.mfa_modules.totp
    sqlalchemy aiohttp-cors hass-frontend pyotp pyqrcode
  ] ++ componentBuildInputs ++ extraBuildInputs;

  checkInputs = [
    pytest requests-mock pydispatcher pytest-aiohttp
  ];

  checkPhase = ''
    # The components' dependencies are not included, so they cannot be tested
    py.test --ignore tests/components
    # Some basic components should be tested however
    py.test \
      tests/components/{group,http,frontend,config,websocket_api} \
      tests/components/test_{api,configurator,demo,discovery,init,introduction,logger,script,shell_command,system_log}.py
  '';

  makeWrapperArgs = lib.optional skipPip "--add-flags --skip-pip";

  meta = with lib; {
    homepage = https://home-assistant.io/;
    description = "Open-source home automation platform running on Python 3";
    license = licenses.asl20;
    maintainers = with maintainers; [ f-breidenstein dotlambda ];
  };
}
