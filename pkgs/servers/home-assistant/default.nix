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
      aioairq = super.aioairq.overridePythonAttrs (oldAttrs: rec {
        version = "0.2.4";
        src = fetchFromGitHub {
          owner = "CorantGmbH";
          repo = "aioairq";
          rev = "refs/tags/v${version}";
          hash = "sha256-+5FyBfsB3kjyX/V9CdZ072mZ3THyvALyym+uk7/kZLo=";
        };
      });

      # https://github.com/home-assistant/core/pull/101913
      aiohttp = super.aiohttp.overridePythonAttrs (old: rec {
        version = "3.8.5";
        src = fetchPypi {
          inherit (old) pname;
          inherit version;
          hash = "sha256-uVUuxSzBR9vxlErHrJivdgLlHqLc0HbtGUyjwNHH0Lw=";
        };
      });

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

      intellifire4py = super.intellifire4py.overridePythonAttrs (oldAttrs: rec {
        version = "2.2.2";
        src = fetchFromGitHub {
          owner = "jeeftor";
          repo = "intellifire4py";
          rev = "refs/tags/${version}";
          hash = "sha256-iqlKfpnETLqQwy5sNcK2x/TgmuN2hCfYoHEFK2WWVXI=";
        };
        nativeBuildInputs = with super; [
          setuptools
        ];
        propagatedBuildInputs = with super; [
          aenum
          aiohttp
          pydantic
        ];
        doCheck = false; # requires asynctest, which does not work on python 3.11
      });

      jaraco-abode = super.jaraco-abode.overridePythonAttrs (oldAttrs: rec {
        version = "3.3.0";
        src = fetchFromGitHub {
          inherit (oldAttrs.src) owner repo;
          rev = "refs/tags/v${version}";
          hash = "sha256-LnbWzIST+GMtdsHDKg67WWt9GmHUcSuGZ5Spei3nEio=";
        };
      });

      justnimbus = super.justnimbus.overridePythonAttrs (oldAttrs: rec {
        version = "0.6.0";
        src = fetchFromGitHub {
          owner = "kvanzuijlen";
          repo = "justnimbus";
          rev = "refs/tags/${version}";
          hash = "sha256-uQ5Nc5sxqHeAuavyfX4Q6Umsd54aileJjFwOOU6X7Yg=";
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

      psutil = super.psutil.overridePythonAttrs (oldAttrs: rec {
        version = "5.9.6";
        src = fetchPypi {
          pname = "psutil";
          inherit version;
          hash = "sha256-5Lkt3NfdTN0/kAGA6h4QSTLHvOI0+4iXbio7KWRBIlo=";
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

      pydexcom = super.pydexcom.overridePythonAttrs (oldAttrs: rec {
        version = "0.2.3";
        src = fetchFromGitHub {
          owner = "gagebenne";
          repo = "pydexcom";
          rev = "refs/tags/${version}";
          hash = "sha256-ItDGnUUUTwCz4ZJtFVlMYjjoBPn2h8QZgLzgnV2T/Qk=";
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

      pysnooz = super.pysnooz.overridePythonAttrs (oldAttrs: rec {
        version = "0.8.6";
        src = fetchFromGitHub {
          owner = "AustinBrunkhorst";
          repo = "pysnooz";
          rev = "refs/tags/v${version}";
          hash = "sha256-hJwIObiuFEAVhgZXYB9VCeAlewBBnk0oMkP83MUCpyU=";
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

      python-tado = super.python-tado.overridePythonAttrs (oldAttrs: rec {
        version = "0.15.0";
        src = fetchFromGitHub {
          owner = "wmalgadey";
          repo = "PyTado";
          rev = "refs/tags/${version}";
          hash = "sha256-gduqQVw/a64aDzTHFmgZu7OVB53jZb7L5vofzL3Ho6s=";
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
  hassVersion = "2023.11.2";

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
    hash = "sha256-cnneRq0hIyvgKo0du/52ze0IVs8TgTPNQM3T1kyy03s=";
  };

  # Secondary source is git for tests
  gitSrc = fetchFromGitHub {
    owner = "home-assistant";
    repo = "core";
    rev = "refs/tags/${version}";
    hash = "sha256-OljfYmlXSJVoWWsd4jcSF4nI/FXHqRA8e4LN5AaPVv8=";
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
    # Follow symlinks in /var/lib/hass/www
    ./patches/static-symlinks.patch

    # Patch path to ffmpeg binary
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
    # AssertionError: assert 'WARNING' not in '2023-11-10 ...nt abc[L]>\n'"
    "--deselect=tests/helpers/test_script.py::test_multiple_runs_repeat_choose"
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
