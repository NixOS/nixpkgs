{ stdenv
, lib
, callPackage
, fetchFromGitHub
, fetchpatch
, python3
, substituteAll
, ffmpeg-headless
, inetutils
, nixosTests
, home-assistant
, testers

# Look up dependencies of specified components in component-packages.nix
, extraComponents ? [ ]

# Additional packages to add to propagatedBuildInputs
, extraPackages ? ps: []

# Write out info about included extraComponents and extraPackages
, writeText

# Override Python packages using
# self: super: { pkg = super.pkg.overridePythonAttrs (oldAttrs: { ... }); }
# Applied after defaultOverrides
, packageOverrides ? self: super: {}

# Skip pip install of required packages on startup
, skipPip ? true }:

let
  defaultOverrides = [
    # Override the version of some packages pinned in Home Assistant's setup.py and requirements_all.txt

    (self: super: {
      # https://github.com/postlund/pyatv/issues/1879
      aiohttp = super.aiohttp.overridePythonAttrs (oldAttrs: rec {
        pname = "aiohttp";
        version = "3.8.1";
        src = self.fetchPypi {
          inherit pname version;
          hash = "sha256-/FRx4aVN4V73HBvG6+gNTcaB6mAOaL/Ry85AQn8LdXg=";
        };
      });

      astral = super.astral.overridePythonAttrs (oldAttrs: rec {
        pname = "astral";
        version = "2.2";
        src = self.fetchPypi {
          inherit pname version;
          hash = "sha256-5B2ZZ9XEi+QhNGVS8PTe2tQ/85qDV09f8q0ytmJ7b74=";
        };
        postPatch = ''
          substituteInPlace pyproject.toml \
            --replace "poetry.masonry" "poetry.core.masonry"
        '';
        propagatedBuildInputs = oldAttrs.propagatedBuildInputs ++ [
          self.pytz
        ];
      });

      caldav = super.caldav.overridePythonAttrs (old: rec {
        version = "0.9.1";
        src = fetchFromGitHub {
          owner = "python-caldav";
          repo = "caldav";
          rev = "v${version}";
          hash = "sha256-Gil0v4pGyp5+TnYPjb8Vk0xTqnQKaeD8Ko/ZWhvkbUk=";
        };
        postPatch = ''
          substituteInPlace setup.py \
            --replace ", 'xandikos<0.2.4'" "" \
            --replace ", 'radicale'" ""
        '';
        checkInputs = old.checkInputs ++ [ self.nose ];
      });

      gridnet = super.gridnet.overridePythonAttrs (oldAttrs: rec {
        version = "4.0.0";
        src = fetchFromGitHub {
          owner = "klaasnicolaas";
          repo = "python-gridnet";
          rev = "refs/tags/v${version}";
          hash = "sha256-Ihs8qUx50tAUcRBsVArRhzoLcQUi1vbYh8sPyK75AEk=";
        };
      });

      # Pinned due to API changes in 0.1.0
      poolsense = super.poolsense.overridePythonAttrs (oldAttrs: rec {
        version = "0.0.8";
        src = super.fetchPypi {
          pname = "poolsense";
          inherit version;
          hash = "sha256-17MHrYRmqkH+1QLtgq2d6zaRtqvb9ju9dvPt9gB2xCc=";
        };
      });

      # Pinned due to API changes >0.3.5.3
      pyatag = super.pyatag.overridePythonAttrs (oldAttrs: rec {
        version = "0.3.5.3";
        src = fetchFromGitHub {
          owner = "MatsNl";
          repo = "pyatag";
          rev = version;
          sha256 = "00ly4injmgrj34p0lyx7cz2crgnfcijmzc0540gf7hpwha0marf6";
        };
      });

      python-slugify = super.python-slugify.overridePythonAttrs (oldAttrs: rec {
        pname = "python-slugify";
        version = "4.0.1";
        src = super.fetchPypi {
          inherit pname version;
          hash = "sha256-aaUXdm4AwSaOW7/A0BCgqFCN4LGNMK1aH/NX+K5yQnA=";
        };
      });

      pytradfri = super.pytradfri.overridePythonAttrs (oldAttrs: rec {
        version = "9.0.0";
        src = fetchFromGitHub {
          owner = "home-assistant-libs";
          repo = "pytradfri";
          rev = "refs/tags/${version}";
          hash = "sha256-12ol+2CnoPfkxmDGJJAkoafHGpQuWC4lh0N7lSvx2DE=";
        };
      });

      pysoma = super.pysoma.overridePythonAttrs (oldAttrs: rec {
        version = "0.0.10";
        src = super.fetchPypi {
          pname = "pysoma";
          inherit version;
          hash = "sha256-sU1qHbAjdIUu0etjate8+U1zvunbw3ddBtDVUU10CuE=";
        };
      });

      # Pinned due to API changes in 0.3.0
      tailscale = super.tailscale.overridePythonAttrs (oldAttrs: rec {
        version = "0.2.0";
        src = fetchFromGitHub {
          owner = "frenck";
          repo = "python-tailscale";
          rev = "refs/tags/v${version}";
          hash = "sha256-/tS9ZMUWsj42n3MYPZJYJELzX3h02AIHeRZmD2SuwWE=";
        };
      });

      # Pinned due to API changes in 0.4.0
      vilfo-api-client = super.vilfo-api-client.overridePythonAttrs (oldAttrs: rec {
        version = "0.3.3";
        src = fetchFromGitHub {
          owner = "ManneW";
          repo = "vilfo-api-client-python";
          rev = "v${version}";
          sha256 = "1gy5gpsg99rcm1cc3m30232za00r9i46sp74zpd12p3vzz1wyyqf";
        };
      });

      # Pinned due to API changes ~1.0
      vultr = super.vultr.overridePythonAttrs (oldAttrs: rec {
        version = "0.1.2";
        src = fetchFromGitHub {
          owner = "spry-group";
          repo = "python-vultr";
          rev = "v${version}";
          sha256 = "1qjvvr2v9gfnwskdl0ayazpcmiyw9zlgnijnhgq9mcri5gq9jw5h";
        };
      });

      # home-assistant-frontend does not exist in python3.pkgs
      home-assistant-frontend = self.callPackage ./frontend.nix { };
    })
  ];

  python = python3.override {
    # Put packageOverrides at the start so they are applied after defaultOverrides
    packageOverrides = lib.foldr lib.composeExtensions (self: super: { }) ([ packageOverrides ] ++ defaultOverrides);
  };

  componentPackages = import ./component-packages.nix;

  availableComponents = builtins.attrNames componentPackages.components;

  inherit (componentPackages) supportedComponentsWithTests;

  getPackages = component: componentPackages.components.${component};

  componentBuildInputs = lib.concatMap (component: getPackages component python.pkgs) extraComponents;

  # Ensure that we are using a consistent package set
  extraBuildInputs = extraPackages python.pkgs;

  # Create info about included packages and components
  extraComponentsFile = writeText "home-assistant-components" (lib.concatStringsSep "\n" extraComponents);
  extraPackagesFile = writeText "home-assistant-packages" (lib.concatMapStringsSep "\n" (pkg: pkg.pname) extraBuildInputs);

  # Don't forget to run parse-requirements.py after updating
  hassVersion = "2023.1.3";

in python.pkgs.buildPythonApplication rec {
  pname = "homeassistant";
  version = assert (componentPackages.version == hassVersion); hassVersion;
  format = "pyproject";

  # check REQUIRED_PYTHON_VER in homeassistant/const.py
  disabled = python.pythonOlder "3.9";

  # don't try and fail to strip 6600+ python files, it takes minutes!
  dontStrip = true;

  # PyPI tarball is missing tests/ directory
  src = fetchFromGitHub {
    owner = "home-assistant";
    repo = "core";
    rev = "refs/tags/${version}";
    hash = "sha256-BYUh6rOW6GgOSaN9zDtwn+aiHcNI5BBns9jPc3A3DdI=";
  };

  # leave this in, so users don't have to constantly update their downstream patch handling
  patches = [
    (substituteAll {
      src = ./patches/ffmpeg-path.patch;
      ffmpeg = "${lib.getBin ffmpeg-headless}/bin/ffmpeg";
    })
  ];

  postPatch = let
    relaxedConstraints = [
      "aiohttp"
      "attrs"
      "awesomeversion"
      "bcrypt"
      "ciso8601"
      "cryptography"
      "home-assistant-bluetooth"
      "httpx"
      "ifaddr"
      "orjson"
      "PyJWT"
      "requests"
      "typing-extensions"
      "yarl"
    ];
  in ''
    sed -r -i \
      ${lib.concatStringsSep "\n" (map (package:
        ''-e 's/${package}[<>=]+.*/${package}",/g' \''
      ) relaxedConstraints)}
      pyproject.toml
    substituteInPlace tests/test_config.py --replace '"/usr"' '"/build/media"'
  '';

  propagatedBuildInputs = with python.pkgs; [
    # Only packages required in setup.py
    aiohttp
    astral
    async-timeout
    atomicwrites-homeassistant
    attrs
    awesomeversion
    bcrypt
    certifi
    ciso8601
    cryptography
    httpx
    home-assistant-bluetooth
    ifaddr
    jinja2
    lru-dict
    orjson
    pip
    pyjwt
    python-slugify
    pyyaml
    requests
    voluptuous
    voluptuous-serialize
    yarl
    # Not in setup.py, but used in homeassistant/util/package.py
    setuptools
    # Not in setup.py, but uncounditionally imported via tests/conftest.py
    paho-mqtt
  ] ++ componentBuildInputs ++ extraBuildInputs;

  makeWrapperArgs = lib.optional skipPip "--add-flags --skip-pip";

  # upstream only tests on Linux, so do we.
  doCheck = stdenv.isLinux;

  checkInputs = with python.pkgs; [
    # test infrastructure (selectively from requirement_test.txt)
    freezegun
    pytest-asyncio
    pytest-aiohttp
    pytest-freezegun
    pytest-mock
    pytest-rerunfailures
    pytest-socket
    pytest-unordered
    pytest-xdist
    pytestCheckHook
    requests-mock
    respx
    stdlib-list
    # required by tests/auth/mfa_modules
    pyotp
  ] ++ lib.concatMap (component: getPackages component python.pkgs) [
    # some components are needed even if tests in tests/components are disabled
    "default_config"
    "hue"
  ];

  pytestFlagsArray = [
    # assign tests grouped by file to workers
    "--dist loadfile"
    # retry racy tests that end in "RuntimeError: Event loop is closed"
    "--reruns 3"
    "--only-rerun RuntimeError"
    # enable full variable printing on error
    "--showlocals"
    # helpers/test_system_info.py: AssertionError: assert 'Unknown' == 'Home Assistant Container'
    "--deselect tests/helpers/test_system_info.py::test_container_installationtype"
    # tests are located in tests/
    "tests"
  ];

  disabledTestPaths = [
    # we neither run nor distribute hassfest
    "tests/hassfest"
    # we don't care about code quality
    "tests/pylint"
    # don't bulk test all components
    "tests/components"
    # pyotp since v2.4.0 complains about the short mock keys, hass pins v2.3.0
    "tests/auth/mfa_modules/test_notify.py"
  ];

  disabledTests = [
    # AssertionError: assert 1 == 0
    "test_merge"
    # Tests are flaky
    "test_config_platform_valid"
    # Test requires pylint>=2.13.0
    "test_invalid_discovery_info"
  ];

  preCheck = ''
    export HOME="$TEMPDIR"

    # the tests require the existance of a media dir
    mkdir /build/media

    # put ping binary into PATH, e.g. for wake_on_lan tests
    export PATH=${inetutils}/bin:$PATH
  '';

  postInstall = ''
    cp -v ${extraComponentsFile} $out/extra_components
    cp -v ${extraPackagesFile} $out/extra_packages
  '';

  passthru = {
    inherit
      availableComponents
      extraComponents
      getPackages
      python
      supportedComponentsWithTests;
    tests = {
      nixos = nixosTests.home-assistant;
      components = callPackage ./tests.nix { };
      version = testers.testVersion {
        package = home-assistant;
        command = "hass --version";
      };
    };
  };

  meta = with lib; {
    homepage = "https://home-assistant.io/";
    description = "Open source home automation that puts local control and privacy first";
    license = licenses.asl20;
    maintainers = teams.home-assistant.members;
    platforms = platforms.linux;
  };
}
