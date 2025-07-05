{
  stdenv,
  lib,
  callPackage,
  fetchFromGitHub,
  fetchPypi,
  python313,
  replaceVars,
  ffmpeg-headless,
  inetutils,
  nixosTests,
  home-assistant,
  testers,

  # Look up dependencies of specified components in component-packages.nix
  extraComponents ? [ ],

  # Additional packages to add to propagatedBuildInputs
  extraPackages ? ps: [ ],

  # Override Python packages using
  # self: super: { pkg = super.pkg.overridePythonAttrs (oldAttrs: { ... }); }
  # Applied after defaultOverrides
  packageOverrides ? self: super: { },

  # Skip pip install of required packages on startup
  skipPip ? true,
}:

let
  defaultOverrides = [
    # Override the version of some packages pinned in Home Assistant's setup.py and requirements_all.txt

    (self: super: {
      aioelectricitymaps = super.aioelectricitymaps.overridePythonAttrs (oldAttrs: rec {
        version = "0.4.0";
        src = fetchFromGitHub {
          owner = "jpbede";
          repo = "aioelectricitymaps";
          rev = "refs/tags/v${version}";
          hash = "sha256-q06B40c0uvSuzH/3YCoxg4p9aNIOPrphsoESktF+B14=";
        };
        nativeCheckInputs = with self; [
          aresponses
        ];
      });

      aioskybell = super.aioskybell.overridePythonAttrs (oldAttrs: rec {
        version = "22.7.0";
        src = fetchFromGitHub {
          owner = "tkdrob";
          repo = "aioskybell";
          rev = "refs/tags/${version}";
          hash = "sha256-aBT1fDFtq1vasTvCnAXKV2vmZ6LBLZqRCiepv1HDJ+Q=";
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
        postPatch = ''
          substituteInPlace pyproject.toml --replace-fail \
            '"setuptools >= 35.0.2", "wheel >= 0.29.0", "poetry>=0.12"' \
            '"poetry-core"'
        '';
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
            --replace-fail "poetry>=1.0.0b1" "poetry-core" \
            --replace-fail "poetry.masonry" "poetry.core.masonry"
        '';
        propagatedBuildInputs = (oldAttrs.propagatedBuildInputs or [ ]) ++ [
          self.pytz
        ];
      });

      async-timeout = super.async-timeout.overridePythonAttrs (oldAttrs: rec {
        version = "4.0.3";
        src = fetchFromGitHub {
          owner = "aio-libs";
          repo = "async-timeout";
          tag = "v${version}";
          hash = "sha256-gJGVRm7YMWnVicz2juHKW8kjJBxn4/vQ/kc2kQyl1i4=";
        };
      });

      av = super.av.overridePythonAttrs (rec {
        version = "13.1.0";
        src = fetchFromGitHub {
          owner = "PyAV-Org";
          repo = "PyAV";
          tag = "v${version}";
          hash = "sha256-x2a9SC4uRplC6p0cD7fZcepFpRidbr6JJEEOaGSWl60=";
        };
      });

      brother = super.brother.overridePythonAttrs (rec {
        version = "4.3.1";
        src = fetchFromGitHub {
          owner = "bieniu";
          repo = "brother";
          tag = version;
          hash = "sha256-fWa5FNBGV8tnJ3CozMicXLGsDvnTjNzU8PdV266MeeQ=";
        };
      });

      google-genai = super.google-genai.overridePythonAttrs (old: rec {
        version = "1.7.0";
        src = fetchFromGitHub {
          owner = "googleapis";
          repo = "python-genai";
          tag = "v${version}";
          hash = "sha256-vmrFPE7H9s9varrP0s6WK4opoU1hREH7rVVjrKiXY5E=";
        };
      });

      gspread = super.gspread.overridePythonAttrs (oldAttrs: rec {
        version = "5.12.4";
        src = fetchFromGitHub {
          owner = "burnash";
          repo = "gspread";
          rev = "refs/tags/v${version}";
          hash = "sha256-i+QbnF0Y/kUMvt91Wzb8wseO/1rZn9xzeA5BWg1haks=";
        };
        dependencies = with self; [
          requests
        ];
      });

      mcp = super.mcp.overridePythonAttrs (oldAttrs: rec {
        version = "1.5.0";
        src = fetchFromGitHub {
          inherit (oldAttrs.src) owner repo;
          tag = "v${version}";
          hash = "sha256-Z2NN6k4mD6NixDON1MUOELpBZW9JvMvFErcCbFPdg2o=";
        };
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

        nativeBuildInputs = with self; [
          setuptools
        ];

        propagatedBuildInputs = with self; [
          requests
        ];

        doCheck = false; # no tests
      });

      openhomedevice = super.openhomedevice.overridePythonAttrs (oldAttrs: rec {
        version = "2.2";
        src = fetchFromGitHub {
          inherit (oldAttrs.src) owner repo;
          rev = "refs/tags/${version}";
          hash = "sha256-GGp7nKFH01m1KW6yMkKlAdd26bDi8JDWva6OQ0CWMIw=";
        };
      });

      plexapi = super.plexapi.overrideAttrs (oldAttrs: rec {
        version = "4.15.16";
        src = fetchFromGitHub {
          owner = "pkkid";
          repo = "python-plexapi";
          tag = version;
          hash = "sha256-NwGGNN6LC3gvE8zoVL5meNWMbqZjJ+6PcU2ebJTfJmU=";
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

      pyflume = super.pyflume.overridePythonAttrs (oldAttrs: rec {
        version = "0.6.5";
        src = fetchFromGitHub {
          owner = "ChrisMandich";
          repo = "PyFlume";
          rev = "refs/tags/v${version}";
          hash = "sha256-kIE3y/qlsO9Y1MjEQcX0pfaBeIzCCHk4f1Xa215BBHo=";
        };
        dependencies = oldAttrs.propagatedBuildInputs or [ ] ++ [
          self.pytz
        ];
      });

      pykaleidescape = super.pykaleidescape.overridePythonAttrs (oldAttrs: rec {
        version = "1.0.1";
        src = fetchFromGitHub {
          inherit (oldAttrs.src) owner repo;
          rev = "refs/tags/v${version}";
          hash = "sha256-KM/gtpsQ27QZz2uI1t/yVN5no0zp9LZag1duAJzK55g=";
        };
      });

      pyoctoprintapi = super.pyoctoprintapi.overridePythonAttrs (oldAttrs: rec {
        version = "0.1.12";
        src = fetchFromGitHub {
          owner = "rfleming71";
          repo = "pyoctoprintapi";
          rev = "refs/tags/v${version}";
          hash = "sha256-Jf/zYnBHVl3TYxFy9Chy6qNH/eCroZkmUOEWfd62RIo=";
        };
      });

      # snmp component does not support pysnmp 7.0+
      pysnmp = super.pysnmp.overridePythonAttrs (oldAttrs: rec {
        version = "6.2.6";
        src = fetchFromGitHub {
          owner = "lextudio";
          repo = "pysnmp";
          tag = "v${version}";
          hash = "sha256-+FfXvsfn8XzliaGUKZlzqbozoo6vDxUkgC87JOoVasY=";
        };
      });

      pysnmpcrypto = super.pysnmpcrypto.overridePythonAttrs (oldAttrs: rec {
        version = "0.0.4";
        src = fetchFromGitHub {
          owner = "lextudio";
          repo = "pysnmpcrypto";
          tag = "v${version}";
          hash = "sha256-f0w4Nucpe+5VE6nhlnePRH95AnGitXeT3BZb3dhBOTk=";
        };
        build-system = with self; [ setuptools ];
        postPatch = ''
          # ValueError: invalid literal for int() with base 10: 'post0' in File "<string>", line 104, in <listcomp>
          substituteInPlace setup.py --replace \
            "observed_version = [int(x) for x in setuptools.__version__.split('.')]" \
            "observed_version = [36, 2, 0]"
        '';
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

      pytradfri = super.pytradfri.overridePythonAttrs (oldAttrs: rec {
        version = "9.0.1";
        src = fetchFromGitHub {
          owner = "home-assistant-libs";
          repo = "pytradfri";
          rev = "refs/tags/${version}";
          hash = "sha256-xOdTzG0bF5p1QpkXv2btwrVugQRjSwdAj8bXcC0IoQg=";
        };
        patches = [ ];
        doCheck = false;
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

      wolf-comm = super.wolf-comm.overridePythonAttrs (rec {
        version = "0.0.23";
        src = fetchFromGitHub {
          owner = "janrothkegel";
          repo = "wolf-comm";
          tag = version;
          hash = "sha256-LpehooW3vmohiyMwOQTFNLiNCsaLKelWQxQk8bl+y1k=";
        };
      });

      # internal python packages only consumed by home-assistant itself
      hass-web-proxy-lib = self.callPackage ./python-modules/hass-web-proxy-lib { };
      home-assistant-frontend = self.callPackage ./frontend.nix { };
      home-assistant-intents = self.callPackage ./intents.nix { };
      homeassistant = self.toPythonModule home-assistant;
      pytest-homeassistant-custom-component =
        self.callPackage ./pytest-homeassistant-custom-component.nix
          { };
    })
  ];

  python = python313.override {
    self = python;
    packageOverrides = lib.composeManyExtensions (defaultOverrides ++ [ packageOverrides ]);
  };

  componentPackages = import ./component-packages.nix;

  availableComponents = builtins.attrNames componentPackages.components;

  inherit (componentPackages) supportedComponentsWithTests;

  getPackages = component: componentPackages.components.${component};

  componentBuildInputs = lib.concatMap (component: getPackages component python.pkgs) extraComponents;

  # Ensure that we are using a consistent package set
  extraBuildInputs = extraPackages python.pkgs;

  # Don't forget to run update-component-packages.py after updating
  hassVersion = "2025.7.1";

in
python.pkgs.buildPythonApplication rec {
  pname = "homeassistant";
  version =
    assert (componentPackages.version == hassVersion);
    hassVersion;
  pyproject = true;

  # check REQUIRED_PYTHON_VER in homeassistant/const.py
  disabled = python.pythonOlder "3.13";

  # don't try and fail to strip 6600+ python files, it takes minutes!
  dontStrip = true;

  # Primary source is the git, which has the tests and allows bisecting the core
  src = fetchFromGitHub {
    owner = "home-assistant";
    repo = "core";
    tag = version;
    hash = "sha256-KaepdkW1PLbWf7yl90ZqmZ6OIgZlRcaw2pSf2wTev+Q=";
  };

  # Secondary source is pypi sdist for translations
  sdist = fetchPypi {
    inherit pname version;
    hash = "sha256-Gmq42r4O6mNNXaVwTlC3UjeAsu8TOm417WCm/2E3I6E=";
  };

  build-system = with python.pkgs; [
    setuptools
  ];

  pythonRelaxDeps = true;

  # extract translations from pypi sdist
  prePatch = ''
    tar --extract --gzip --file $sdist --strip-components 1 --wildcards "**/translations"
  '';

  # leave this in, so users don't have to constantly update their downstream patch handling
  patches = [
    # Follow symlinks in /var/lib/hass/www
    ./patches/static-follow-symlinks.patch

    # Copy default blueprints without preserving permissions
    ./patches/default-blueprint-permissions.patch

    # Patch path to ffmpeg binary
    (replaceVars ./patches/ffmpeg-path.patch {
      ffmpeg = "${lib.getExe ffmpeg-headless}";
    })
  ];

  postPatch = ''
    substituteInPlace tests/test_core_config.py --replace-fail '"/usr"' "\"$NIX_BUILD_TOP/media\""

    substituteInPlace pyproject.toml \
      --replace-fail "setuptools==78.1.1" setuptools
  '';

  dependencies = with python.pkgs; [
    # Only packages required in pyproject.toml
    aiodns
    aiofiles
    aiohasupervisor
    aiohttp
    aiohttp-asyncmdnsresolver
    aiohttp-cors
    aiohttp-fast-zlib
    aiozoneinfo
    annotatedyaml
    astral
    async-interrupt
    atomicwrites-homeassistant
    attrs
    audioop-lts
    awesomeversion
    bcrypt
    certifi
    ciso8601
    cronsim
    cryptography
    fnv-hash-fast
    ha-ffmpeg
    hass-nabucasa
    hassil
    home-assistant-bluetooth
    home-assistant-intents
    httpx
    ifaddr
    jinja2
    lru-dict
    mutagen
    numpy
    orjson
    packaging
    pillow
    propcache
    psutil-home-assistant
    pyjwt
    pymicro-vad
    pyopenssl
    pyspeex-noise
    python-slugify
    pyturbojpeg
    pyyaml
    requests
    securetar
    sqlalchemy
    standard-aifc
    standard-telnetlib
    typing-extensions
    ulid-transform
    urllib3
    uv
    voluptuous
    voluptuous-openapi
    voluptuous-serialize
    webrtc-models
    yarl
    zeroconf
    # REQUIREMENTS in homeassistant/auth/mfa_modules/totp.py and homeassistant/auth/mfa_modules/notify.py
    pyotp
    pyqrcode
  ];

  makeWrapperArgs = lib.optional skipPip "--add-flags --skip-pip";

  # upstream only tests on Linux, so do we.
  doCheck = stdenv.hostPlatform.isLinux;

  nativeCheckInputs =
    with python.pkgs;
    [
      # test infrastructure (selectively from requirement_test.txt)
      freezegun
      pytest-asyncio
      pytest-aiohttp
      pytest-freezer
      pytest-mock
      pytest-socket
      pytest-timeout
      pytest-unordered
      pytest-xdist
      pytestCheckHook
      requests-mock
      respx
      syrupy
      tomli
      # Sneakily imported in tests/conftest.py
      paho-mqtt
      # Used in tests/non_packaged_scripts/test_alexa_locales.py
      beautifulsoup4
    ]
    ++ lib.concatMap (component: getPackages component python.pkgs) [
      # some components are needed even if tests in tests/components are disabled
      "default_config"
      "hue"
      "qwikswitch"
    ];

  pytestFlagsArray = [
    # assign tests grouped by file to workers
    "--dist loadfile"
    # enable full variable printing on error
    "--showlocals"
    # AssertionError: assert 1 == 0
    "--deselect tests/test_config.py::test_merge"
    # checks whether pip is installed
    "--deselect=tests/util/test_package.py::test_check_package_fragment"
    # flaky
    "--deselect=tests/test_bootstrap.py::test_setup_hass_takes_longer_than_log_slow_startup"
    "--deselect=tests/test_test_fixtures.py::test_evict_faked_translations"
    "--deselect=tests/helpers/test_backup.py::test_async_get_manager"
    # (2025.7.0) Fails to find name of tracked time interval in scheduled jobs
    "--deselect=tests/helpers/test_event.py::test_track_time_interval_name"
    # tests are located in tests/
    "tests"
  ];

  disabledTestPaths = [
    # we neither run nor distribute hassfest
    "tests/hassfest"
    # we don't care about code quality
    "tests/pylint"
    # redundant component import test, which would make debugpy & sentry expensive to review
    "tests/test_circular_imports.py"
    # don't bulk test all components
    "tests/components"
  ];

  preCheck = ''
    export HOME="$TEMPDIR"

    # the tests require the existance of a media dir
    mkdir "$NIX_BUILD_TOP"/media

    # put ping binary into PATH, e.g. for wake_on_lan tests
    export PATH=${inetutils}/bin:$PATH
  '';

  passthru = {
    inherit
      availableComponents
      extraComponents
      getPackages
      python
      supportedComponentsWithTests
      ;
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
      withoutCheckDeps = home-assistant.overridePythonAttrs {
        pname = "home-assistant-without-check-deps";
        doCheck = false;
      };
    };
  };

  meta = with lib; {
    homepage = "https://home-assistant.io/";
    changelog = "https://github.com/home-assistant/core/releases/tag/${src.tag}";
    description = "Open source home automation that puts local control and privacy first";
    license = licenses.asl20;
    teams = [ teams.home-assistant ];
    platforms = platforms.linux;
    mainProgram = "hass";
  };
}
