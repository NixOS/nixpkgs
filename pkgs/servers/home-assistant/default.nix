{ stdenv
, lib
, callPackage
, fetchFromGitHub
, fetchpatch
, python3
, substituteAll
, ffmpeg
, inetutils
, nixosTests

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
      advantage-air = super.advantage-air.overridePythonAttrs (oldAttrs: rec {
        version = "0.3.1";
        src = super.fetchPypi {
          pname = "advantage_air";
          inherit version;
          hash = "sha256-C+cB6oHmbr9mHZKnbls42yenQy3+L8huLk9wKazIWfU=";
        };
      });
    })

    (self: super: {
      backoff = super.backoff.overridePythonAttrs (oldAttrs: rec {
        version = "1.11.1";
        src = fetchFromGitHub {
          owner = "litl";
          repo = "backoff";
          rev = "v${version}";
          hash = "sha256-87IMcLaoCn0Vns8Ub/AFmv0gXtS0aPZX0cSt7+lOPm4=";
        };
      });
    })

    (self: super: {
      bsblan = super.bsblan.overridePythonAttrs (oldAttrs: rec {
        version = "0.5.0";
        postPatch = null;
        propagatedBuildInputs = oldAttrs.propagatedBuildInputs ++ [ super.cattrs ];
        src = fetchFromGitHub {
          owner = "liudger";
          repo = "python-bsblan";
          rev = "v.${version}";
          hash = "sha256-yzlHcIb5QlG+jAgEtKlAcY7rESiUY7nD1YwqK63wgcg=";
        };
      });
    })

    (self: super: {
      gridnet = super.gridnet.overridePythonAttrs (oldAttrs: rec {
        version = "4.0.0";
        src = fetchFromGitHub {
          owner = "klaasnicolaas";
          repo = "python-gridnet";
          rev = "refs/tags/v${version}";
          hash = "sha256-Ihs8qUx50tAUcRBsVArRhzoLcQUi1vbYh8sPyK75AEk=";
        };
      });
    })

    (self: super: {
      p1monitor = super.p1monitor.overridePythonAttrs (oldAttrs: rec {
        version = "1.0.1";
        src = fetchFromGitHub {
          owner = "klaasnicolaas";
          repo = "python-p1monitor";
          rev = "refs/tags/v${version}";
          hash = "sha256-g3isA2gF2AD+VVzTqpnD+YiJQ9Kcl0VKvwd5l5Yx/Uo=";
        };
      });
    })

    # pytest-aiohttp>0.3.0 breaks home-assistant tests
    (self: super: {
      pytest-aiohttp = super.pytest-aiohttp.overridePythonAttrs (oldAttrs: rec {
        version = "0.3.0";
        src = self.fetchPypi {
          inherit version;
          pname = "pytest-aiohttp";
          hash = "sha256-ySmFQzljeXc3WDhwO2L+9jUoWYvAqdRRY566lfSqpE8=";
        };
        propagatedBuildInputs = with python3.pkgs; [ aiohttp pytest ];
        doCheck = false;
        patches = [];
      });
      aiohomekit = super.aiohomekit.overridePythonAttrs (oldAttrs: {
        doCheck = false; # requires aiohttp>=1.0.0
      });
      gcal-sync = super.gcal-sync.overridePythonAttrs (oldAttrs: {
        doCheck = false; # requires aiohttp>=1.0.0
      });
      hass-nabucasa = super.hass-nabucasa.overridePythonAttrs (oldAttrs: {
        doCheck = false; # requires aiohttp>=1.0.0
      });
      pynws = super.pynws.overridePythonAttrs (oldAttrs: {
        doCheck = false; # requires pytest-aiohttp>=1.0.0
      });
      pytomorrowio = super.pytomorrowio.overridePythonAttrs (oldAttrs: {
        doCheck = false; # requires pytest-aiohttp>=1.0.0
      });
      rtsp-to-webrtc = super.rtsp-to-webrtc.overridePythonAttrs (oldAttrs: {
        doCheck = false; # requires pytest-aiohttp>=1.0.0
      });
      snitun = super.snitun.overridePythonAttrs (oldAttrs: {
        doCheck = false; # requires aiohttp>=1.0.0
      });
      zwave-js-server-python = super.zwave-js-server-python.overridePythonAttrs (oldAttrs: {
        doCheck = false; # requires aiohttp>=1.0.0
      });
    })

    (self: super: {
      plugwise = super.plugwise.overridePythonAttrs (oldAttrs: rec {
        version = "0.20.1";
        src = fetchFromGitHub {
          owner = "plugwise";
          repo = "python-plugwise";
          rev = "refs/tags/v${version}";
          hash = "sha256-Sk7L0JPwn7IXVl5GeERxrG/vrHXeNwUjW1mgm4g40Ng=";
        };
      });
    })

    # Pinned due to API changes in 0.1.0
    (self: super: {
      poolsense = super.poolsense.overridePythonAttrs (oldAttrs: rec {
        version = "0.0.8";
        src = super.fetchPypi {
          pname = "poolsense";
          inherit version;
          hash = "sha256-17MHrYRmqkH+1QLtgq2d6zaRtqvb9ju9dvPt9gB2xCc=";
        };
      });
    })

    # Pinned due to API changes >0.3.5.3
    (self: super: {
      pyatag = super.pyatag.overridePythonAttrs (oldAttrs: rec {
        version = "0.3.5.3";
        src = fetchFromGitHub {
          owner = "MatsNl";
          repo = "pyatag";
          rev = version;
          sha256 = "00ly4injmgrj34p0lyx7cz2crgnfcijmzc0540gf7hpwha0marf6";
        };
      });
    })

    (self: super: {
      pyatmo = super.pyatmo.overridePythonAttrs (oldAttrs: rec {
        version = "6.2.4";
        src = fetchFromGitHub {
          owner = "jabesq";
          repo = "pyatmo";
          rev = "refs/tags/v${version}";
          hash = "sha256-VXkQByaNA02fwBO2yuf7w1ZF/oJwd/h21de1EQlCu2U=";
        };
        checkInputs = [ super.freezegun ];
      });
    })

    # pyunifiprotect excludes pydantic==1.9.1
    (self: super: {
      pydantic = super.pydantic.overridePythonAttrs (oldAttrs: rec {
        version = "1.9.0";
        src = fetchFromGitHub {
          owner = "samuelcolvin";
          repo = "pydantic";
          rev = "refs/tags/v${version}";
          hash = "sha256-C4WP8tiMRFmkDkQRrvP3yOSM2zN8pHJmX9cdANIckpM=";
        };
      });
    })

    (self: super: {
      pydeconz = super.pydeconz.overridePythonAttrs (oldAttrs: rec {
        doCheck = false; # requires pytest-aiohttp>=1.0.0
      });
    })


    (self: super: {
      python-slugify = super.python-slugify.overridePythonAttrs (oldAttrs: rec {
        pname = "python-slugify";
        version = "4.0.1";
        src = super.fetchPypi {
          inherit pname version;
          hash = "sha256-aaUXdm4AwSaOW7/A0BCgqFCN4LGNMK1aH/NX+K5yQnA=";
        };
      });
    })

    (self: super: {
      pytradfri = super.pytradfri.overridePythonAttrs (oldAttrs: rec {
        version = "9.0.0";
        src = fetchFromGitHub {
          owner = "home-assistant-libs";
          repo = "pytradfri";
          rev = "refs/tags/${version}";
          hash = "sha256-12ol+2CnoPfkxmDGJJAkoafHGpQuWC4lh0N7lSvx2DE=";
        };
      });
    })

    (self: super: {
      solax = super.solax.overridePythonAttrs (oldAttrs: rec {
        version = "0.2.9";
        src = super.fetchPypi {
          pname = "solax";
          inherit version;
          hash = "sha256-5m2wxdTshAsEfldPAyXqAYYtH1VjqERRBUGzX6pV85I=";
        };
      });
    })

    (self: super: {
      pysoma = super.pysoma.overridePythonAttrs (oldAttrs: rec {
        version = "0.0.10";
        src = super.fetchPypi {
          pname = "pysoma";
          inherit version;
          hash = "sha256-sU1qHbAjdIUu0etjate8+U1zvunbw3ddBtDVUU10CuE=";
        };
      });
    })

    # Pinned due to API changes in 0.4.0
    (self: super: {
      vilfo-api-client = super.vilfo-api-client.overridePythonAttrs (oldAttrs: rec {
        version = "0.3.3";
        src = fetchFromGitHub {
          owner = "ManneW";
          repo = "vilfo-api-client-python";
          rev = "v${version}";
          sha256 = "1gy5gpsg99rcm1cc3m30232za00r9i46sp74zpd12p3vzz1wyyqf";
        };
      });
    })

    # Pinned due to API changes ~1.0
    (self: super: {
      vultr = super.vultr.overridePythonAttrs (oldAttrs: rec {
        version = "0.1.2";
        src = fetchFromGitHub {
          owner = "spry-group";
          repo = "python-vultr";
          rev = "v${version}";
          sha256 = "1qjvvr2v9gfnwskdl0ayazpcmiyw9zlgnijnhgq9mcri5gq9jw5h";
        };
      });
    })

    # home-assistant-frontend does not exist in python3.pkgs
    (self: super: {
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
  hassVersion = "2022.8.7";

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
    rev = version;
    hash = "sha256-FkI0EHO+M3dpt5xt73QkneQlCqgYUGKuO9MT3bRK2jI=";
  };

  # leave this in, so users don't have to constantly update their downstream patch handling
  patches = [
    (substituteAll {
      src = ./patches/ffmpeg-path.patch;
      ffmpeg = "${lib.getBin ffmpeg}/bin/ffmpeg";
    })
    ./patches/wilight-import.patch
  ];

  postPatch = let
    relaxedConstraints = [
      "attrs"
      "awesomeversion"
      "bcrypt"
      "cryptography"
      "home-assistant-bluetooth"
      "httpx"
      "ifaddr"
      "orjson"
      "PyJWT"
      "requests"
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
    pytest-aiohttp
    pytest-freezegun
    pytest-mock
    pytest-rerunfailures
    pytest-socket
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
