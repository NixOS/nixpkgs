{ stdenv
, lib
, callPackage
, fetchFromGitHub
, fetchPypi
, python311
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
      aiowatttime = super.aiowatttime.overridePythonAttrs (oldAttrs: rec {
        version = "0.1.1";
        src = fetchFromGitHub {
          owner = "bachya";
          repo = "aiowatttime";
          rev = "refs/tags/${version}";
          hash = "sha256-tWnxGLJT+CRFvkhxFamHxnLXBvoR8tfOvzH1o1i5JJg=";
        };
      });

      astral = super.astral.overridePythonAttrs (oldAttrs: rec {
        pname = "astral";
        version = "2.2";
        src = fetchPypi {
          inherit pname version;
          hash = "sha256-5B2ZZ9XEi+QhNGVS8PTe2tQ/85qDV09f8q0ytmJ7b74=";
        };
        postPatch = ''
          substituteInPlace pyproject.toml \
            --replace "poetry>=1.0.0b1" "poetry-core" \
            --replace "poetry.masonry" "poetry.core.masonry"
        '';
        propagatedBuildInputs = oldAttrs.propagatedBuildInputs ++ [
          self.pytz
        ];
      });

      dsmr-parser = super.dsmr-parser.overridePythonAttrs (oldAttrs: rec {
        version = "0.33";
        src = fetchFromGitHub {
          owner = "ndokter";
          repo = "dsmr_parser";
          rev = "refs/tags/v${version}";
          hash = "sha256-Phx8Yqx6beTzkQv0fU8Pfs2btPgKVARdO+nMcne1S+w=";
        };
      });

      geojson = super.geojson.overridePythonAttrs (oldAttrs: rec {
        version = "2.5.0";
        src = fetchFromGitHub {
          inherit (oldAttrs.src) owner repo;
          rev = "refs/tags/${version}";
          hash = "sha256-AcImffYki1gnIaZp/1eacNjdDgjn6qinPJXq9jYtoRg=";
        };
        doCheck = false;
      });

      ha-av = super.av.overridePythonAttrs (oldAttrs: rec {
        pname = "ha-av";
        version = "10.1.1";

        src = fetchPypi {
          inherit pname version;
          hash = "sha256-QaMFVvglipN0kG1+ZQNKk7WTydSyIPn2qa32UtvLidw=";
        };
      });

      jaraco-abode = super.jaraco-abode.overridePythonAttrs (oldAttrs: rec {
        version = "3.3.0";
        src = fetchFromGitHub {
          inherit (oldAttrs.src) owner repo;
          rev = "refs/tags/v${version}";
          hash = "sha256-LnbWzIST+GMtdsHDKg67WWt9GmHUcSuGZ5Spei3nEio=";
        };
      });

      # moto tests are a nuissance
      moto = super.moto.overridePythonAttrs (_: {
        doCheck = false;
      });

      notifications-android-tv = super.notifications-android-tv.overridePythonAttrs (oldAttrs: rec {
        version = "0.1.5";
        format = "setuptools";

        src = fetchFromGitHub {
          owner = "engrbm87";
          repo = "notifications_android_tv";
          rev = "refs/tags/${version}";
          hash = "sha256-adkcUuPl0jdJjkBINCTW4Kmc16C/HzL+jaRZB/Qr09A=";
        };

        nativeBuildInputs = with super; [
          setuptools
        ];

        propagatedBuildInputs = with super; [
          requests
        ];

        doCheck = false; # no tests
      });

      # Pinned due to API changes in 1.3.0
      ovoenergy = super.ovoenergy.overridePythonAttrs (oldAttrs: rec {
        version = "1.2.0";
        src = fetchFromGitHub {
          owner = "timmo001";
          repo = "ovoenergy";
          rev = "refs/tags/v${version}";
          hash = "sha256-OSK74uvpHuEtWgbLVFrz1NO7lvtHbt690smGQ+GlsOI=";
        };
      });

      plexapi = super.plexapi.overridePythonAttrs (oldAttrs: rec {
        version = "4.13.2";
        src = fetchFromGitHub {
          owner = "pkkid";
          repo = "python-plexapi";
          rev = "refs/tags/${version}";
          hash = "sha256-5YwINPgQ4efZBvu5McsLYicW/7keKSi011lthJUR9zw=";
        };
      });

      # Pinned due to API changes in 0.1.0
      poolsense = super.poolsense.overridePythonAttrs (oldAttrs: rec {
        version = "0.0.8";
        src = fetchPypi {
          pname = "poolsense";
          inherit version;
          hash = "sha256-17MHrYRmqkH+1QLtgq2d6zaRtqvb9ju9dvPt9gB2xCc=";
        };
      });

      p1monitor = super.p1monitor.overridePythonAttrs (oldAttrs: rec {
        version = "2.1.1";
        src = fetchFromGitHub {
          inherit (oldAttrs.src) owner repo;
          rev = "refs/tags/v${version}";
          hash = "sha256-VHY5AWxt5BZd1NQKzsgubEZBLKAlDNm8toyEazPUnDU=";
        };
      });

      py-synologydsm-api = super.py-synologydsm-api.overridePythonAttrs (oldAttrs: rec {
        version = "2.1.4";
        src = fetchFromGitHub {
          owner = "mib1185";
          repo = "py-synologydsm-api";
          rev = "refs/tags/v${version}";
          hash = "sha256-37JzdhMny6YDTBO9NRzfrZJAVAOPnpcr95fOKxisbTg=";
        };
      });

      pyasn1 = super.pyasn1.overridePythonAttrs (oldAttrs: rec {
        version = "0.4.8";
        src = fetchPypi {
          inherit (oldAttrs) pname;
          inherit version;
          hash = "sha256-rvd8n7lKOsWI6HhBIIvexGRHHZhxvVBQoofMmkdc0Lo=";
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

      pykaleidescape = super.pykaleidescape.overridePythonAttrs (oldAttrs: rec {
        version = "1.0.1";
        src = fetchFromGitHub {
          inherit (oldAttrs.src) owner repo;
          rev = "refs/tags/v${version}";
          hash = "sha256-KM/gtpsQ27QZz2uI1t/yVN5no0zp9LZag1duAJzK55g=";
        };
      });

      python-slugify = super.python-slugify.overridePythonAttrs (oldAttrs: rec {
        pname = "python-slugify";
        version = "4.0.1";
        src = fetchPypi {
          inherit pname version;
          hash = "sha256-aaUXdm4AwSaOW7/A0BCgqFCN4LGNMK1aH/NX+K5yQnA=";
        };
      });

      pytradfri = super.pytradfri.overridePythonAttrs (oldAttrs: rec {
        version = "9.0.1";
        src = fetchFromGitHub {
          owner = "home-assistant-libs";
          repo = "pytradfri";
          rev = "refs/tags/${version}";
          hash = "sha256-xOdTzG0bF5p1QpkXv2btwrVugQRjSwdAj8bXcC0IoQg=";
        };
      });

      python-telegram-bot = super.python-telegram-bot.overridePythonAttrs (oldAttrs: rec {
        version = "13.15";
        src = fetchFromGitHub {
          owner = "python-telegram-bot";
          repo = "python-telegram-bot";
          rev = "v${version}";
          hash = "sha256-EViSjr/nnuJIDTwV8j/O50hJkWV3M5aTNnWyzrinoyg=";
        };
        propagatedBuildInputs = [
          self.apscheduler
          self.cachetools
          self.certifi
          self.cryptography
          self.decorator
          self.future
          self.tornado
          self.urllib3
        ];
        setupPyGlobalFlags = [ "--with-upstream-urllib3" ];
        postPatch = ''
          rm -r telegram/vendor
          substituteInPlace requirements.txt \
            --replace "APScheduler==3.6.3" "APScheduler" \
            --replace "cachetools==4.2.2" "cachetools" \
            --replace "tornado==6.1" "tornado"
        '';
        doCheck = false;
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

      # Pinned due to API changes ~1.0
      vultr = super.vultr.overridePythonAttrs (oldAttrs: rec {
        version = "0.1.2";
        src = fetchFromGitHub {
          owner = "spry-group";
          repo = "python-vultr";
          rev = version;
          hash = "sha256-sHCZ8Csxs5rwg1ZG++hP3MfK7ldeAdqm5ta9tEXeW+I=";
        };
      });

      websockets = super.websockets.overridePythonAttrs (oldAttrs: rec {
        version = "11.0.1";
        src = fetchFromGitHub {
          owner = "aaugustin";
          repo = "websockets";
          rev = "refs/tags/${version}";
          hash = "sha256-cD8pC7n2OGS8AjG0VdjNXi8jXxvN7yKkadNR0GCqc90=";
        };
      });

      zeroconf = super.zeroconf.overridePythonAttrs (oldAttrs: rec {
        version = "0.98.0";
        src = fetchFromGitHub {
          owner = "python-zeroconf";
          repo = "python-zeroconf";
          rev = "refs/tags/${version}";
          hash = "sha256-oajSXGQTsJsajRAnS/MkkbSyxTeVvdjvw1eiJaPzZMY=";
        };
      });

      # internal python packages only consumed by home-assistant itself
      home-assistant-frontend = self.callPackage ./frontend.nix { };
      home-assistant-intents = self.callPackage ./intents.nix { };
    })
  ];

  python = python311.override {
    packageOverrides = lib.composeManyExtensions (defaultOverrides ++ [ packageOverrides ]);
  };

  componentPackages = import ./component-packages.nix;

  availableComponents = builtins.attrNames componentPackages.components;

  inherit (componentPackages) supportedComponentsWithTests;

  getPackages = component: componentPackages.components.${component};

  componentBuildInputs = lib.concatMap (component: getPackages component python.pkgs) extraComponents;

  # Ensure that we are using a consistent package set
  extraBuildInputs = extraPackages python.pkgs;

  # Don't forget to run parse-requirements.py after updating
  hassVersion = "2023.9.3";

in python.pkgs.buildPythonApplication rec {
  pname = "homeassistant";
  version = assert (componentPackages.version == hassVersion); hassVersion;
  format = "pyproject";

  # check REQUIRED_PYTHON_VER in homeassistant/const.py
  disabled = python.pythonOlder "3.10";

  # don't try and fail to strip 6600+ python files, it takes minutes!
  dontStrip = true;

  # Primary source is the pypi sdist, because it contains translations
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-tcIGYJ+r2+0jnf3xUxnFdwnLiOK9P0Y6sw0Mpd/YIT0=";
  };

  # Secondary source is git for tests
  gitSrc = fetchFromGitHub {
    owner = "home-assistant";
    repo = "core";
    rev = "refs/tags/${version}";
    hash = "sha256-zAUMevj2xvRkhZg4wuHDz0+X//cEU/D/HmokmX9oeCU=";
  };

  nativeBuildInputs = with python.pkgs; [
    setuptools
    wheel
  ];

  # copy tests early, so patches apply as they would to the git repo
  prePatch = ''
    cp --no-preserve=mode --recursive ${gitSrc}/tests ./
    chmod u+x tests/auth/providers/test_command_line_cmd.sh
  '';

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
      "pip"
      "PyJWT"
      "pyOpenSSL"
      "PyYAML"
      "requests"
      "typing-extensions"
      "voluptuous-serialize"
      "yarl"
    ];
  in ''
    sed -r -i \
      ${lib.concatStringsSep "\n" (map (package:
        ''-e 's/${package}[<>=]+.*/${package}",/g' \''
      ) relaxedConstraints)}
      pyproject.toml
    substituteInPlace tests/test_config.py --replace '"/usr"' '"/build/media"'

    sed -i 's/setuptools[~=]/setuptools>/' pyproject.toml
    sed -i 's/wheel[~=]/wheel>/' pyproject.toml
  '';

  propagatedBuildInputs = with python.pkgs; [
    # Only packages required in pyproject.toml
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
    packaging
    pip
    pyopenssl
    pyjwt
    python-slugify
    pyyaml
    requests
    ulid-transform
    voluptuous
    voluptuous-serialize
    yarl
    # Implicit dependency via homeassistant/requirements.py
    setuptools
  ];

  makeWrapperArgs = lib.optional skipPip "--add-flags --skip-pip";

  # upstream only tests on Linux, so do we.
  doCheck = stdenv.isLinux;

  nativeCheckInputs = with python.pkgs; [
    # test infrastructure (selectively from requirement_test.txt)
    freezegun
    pytest-asyncio
    pytest-aiohttp
    pytest-freezer
    pytest-mock
    pytest-rerunfailures
    pytest-socket
    pytest-timeout
    pytest-unordered
    pytest-xdist
    pytestCheckHook
    requests-mock
    respx
    stdlib-list
    syrupy
    tomli
    # required through tests/auth/mfa_modules/test_otp.py
    pyotp
    # Sneakily imported in tests/conftest.py
    paho-mqtt
  ] ++ lib.concatMap (component: getPackages component python.pkgs) [
    # some components are needed even if tests in tests/components are disabled
    "default_config"
    "hue"
    # for tests/test_config.py::test_merge_id_schema
    "qwikswitch"
  ];

  pytestFlagsArray = [
    # assign tests grouped by file to workers
    "--dist loadfile"
    # retry racy tests that end in "RuntimeError: Event loop is closed"
    "--reruns 3"
    "--only-rerun RuntimeError"
    # enable full variable printing on error
    "--showlocals"
    # AssertionError: assert 1 == 0
    "--deselect tests/test_config.py::test_merge"
    # AssertionError: assert 2 == 1
    "--deselect=tests/helpers/test_translation.py::test_caching"
    # AssertionError: assert None == RegistryEntry
    "--deselect=tests/helpers/test_entity_registry.py::test_get_or_create_updates_data"
    # AssertionError: assert 2 == 1
    "--deselect=tests/helpers/test_entity_values.py::test_override_single_value"
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
  ];

  preCheck = ''
    export HOME="$TEMPDIR"

    # the tests require the existance of a media dir
    mkdir /build/media

    # put ping binary into PATH, e.g. for wake_on_lan tests
    export PATH=${inetutils}/bin:$PATH
  '';

  passthru = {
    inherit
      availableComponents
      extraComponents
      getPackages
      python
      supportedComponentsWithTests;
    pythonPath = python.pkgs.makePythonPath (componentBuildInputs ++ extraBuildInputs);
    frontend = python.pkgs.home-assistant-frontend;
    intents = python.pkgs.home-assistant-intents;
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
