{ lib, fetchFromGitHub, python3, protobuf3_6

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
    (mkOverride "aiohttp" "3.5.4"
      "9c4c83f4fa1938377da32bc2d59379025ceeee8e24b89f72fcbccd8ca22dc9bf")
    (mkOverride "astral" "1.10.1"
      "d2a67243c4503131c856cafb1b1276de52a86e5b8a1d507b7e08bee51cb67bf1")
    (mkOverride "async-timeout" "3.0.1"
      "0c3c816a028d47f659d6ff5c745cb2acf1f966da1fe5c19c77a70282b25f4c5f")
    (mkOverride "attrs" "19.1.0"
      "f0b870f674851ecbfbbbd364d6b5cbdff9dcedbc7f3f5e18a6891057f21fe399")
    (mkOverride "bcrypt" "3.1.6"
      "44636759d222baa62806bbceb20e96f75a015a6381690d1bc2eda91c01ec02ea")
    (mkOverride "pyjwt" "1.7.1"
      "8d59a976fb773f3e6a39c85636357c4f0e242707394cadadd9814f5cbaa20e96")
    (mkOverride "cryptography" "2.6.1"
      "26c821cbeb683facb966045e2064303029d572a87ee69ca5a1bf54bf55f93ca6")
    (mkOverride "cryptography_vectors" "2.6.1" # required by cryptography==2.6.1
      "03f38115dccb266dd96538f94067442a877932c2322661bdc5bf2502c76658af")
    (mkOverride "python-slugify" "3.0.2"
      "57163ffb345c7e26063435a27add1feae67fa821f1ef4b2f292c25847575d758")
    (mkOverride "requests" "2.21.0"
      "502a824f31acdacb3a35b6690b5fbf0bc41d63a24a45c4004352b0242707598e")
    (mkOverride "ruamel_yaml" "0.15.94"
      "0939bcb399ad037ef903d74ccf2f8a074f06683bc89133ad19305067d34487c8")
    (mkOverride "voluptuous" "0.11.5"
      "567a56286ef82a9d7ae0628c5842f65f516abcb496e74f3f59f1d7b28df314ef")
    (mkOverride "voluptuous-serialize" "2.1.0"
      "d30fef4f1aba251414ec0b315df81a06da7bf35201dcfb1f6db5253d738a154f")

    # used by auth.mfa_modules.totp
    (mkOverride "pyotp" "2.2.7"
      "be0ffeabddaa5ee53e7204e7740da842d070cf69168247a3d0c08541b84de602")

    # used by check_config script
    # can be unpinned once https://github.com/home-assistant/home-assistant/issues/11917 is resolved
    (mkOverride "colorlog" "4.0.2"
      "3cf31b25cbc8f86ec01fef582ef3b840950dea414084ed19ab922c8b493f9b42")

    # required by aioesphomeapi
    (self: super: {
      protobuf = super.protobuf.override {
        protobuf = protobuf3_6;
      };
    })

    (self: super: {
      pyyaml = super.pyyaml_3;
    })

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
  hassVersion = "0.93.2";

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
    sha256 = "01zdg6yfj6qal8jpr9bskmq25crrvz7w3vifrfxmlqws6hv35gc8";
  };

  propagatedBuildInputs = [
    # From setup.py
    aiohttp astral async-timeout attrs bcrypt certifi jinja2 pyjwt cryptography pip
    python-slugify pytz pyyaml requests ruamel_yaml voluptuous voluptuous-serialize
    # From http, frontend and recorder components and auth.mfa_modules.totp
    sqlalchemy aiohttp-cors hass-frontend pyotp pyqrcode
  ] ++ componentBuildInputs ++ extraBuildInputs;

  checkInputs = [
    asynctest pytest pytest-aiohttp requests-mock pydispatcher aiohue
  ];

  checkPhase = ''
    # The components' dependencies are not included, so they cannot be tested
    # test_webhook_create_cloudhook imports hass_nabucasa and is thus excluded
    py.test --ignore tests/components -k "not test_webhook_create_cloudhook"
    # Some basic components should be tested however
    py.test \
      tests/components/{api,config,configurator,demo,discovery,frontend,group,history,history_graph} \
      tests/components/{homeassistant,http,logger,script,shell_command,system_log,websocket_api}
  '';

  makeWrapperArgs = lib.optional skipPip "--add-flags --skip-pip";

  meta = with lib; {
    homepage = https://home-assistant.io/;
    description = "Open-source home automation platform running on Python 3";
    license = licenses.asl20;
    maintainers = with maintainers; [ f-breidenstein dotlambda globin ];
  };
}
