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
      aionotion = super.aionotion.overridePythonAttrs rec {
        version = "2024.03.0";
        src = fetchFromGitHub {
          owner = "bachya";
          repo = "aionotion";
          tag = version;
          hash = "sha256-BsbfLb5wCVxR8v2U2Zzt7LMl7XJcZWfVjZN47VDkhFc=";
        };
        postPatch = null;
      };

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

      av = super.av.overridePythonAttrs rec {
        version = "13.1.0";
        src = fetchFromGitHub {
          owner = "PyAV-Org";
          repo = "PyAV";
          tag = "v${version}";
          hash = "sha256-x2a9SC4uRplC6p0cD7fZcepFpRidbr6JJEEOaGSWl60=";
        };
      };

      imageio = super.imageio.overridePythonAttrs (oldAttrs: {
        disabledTests = oldAttrs.disabledTests or [ ] ++ [
          # broken by pyav pin
          "test_keyframe_intervals"
          "test_lagging_video_stream"
        ];
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

      livisi = super.livisi.overridePythonAttrs (oldAttrs: rec {
        version = "0.0.25";
        src = fetchFromGitHub {
          owner = "planbnet";
          repo = "livisi";
          tag = "v${version}";
          hash = "sha256-kEkbuZmYzxhrbTdo7eZJYu2N2uJtfspgqepplXvSXFg=";
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

      py-madvr2 = super.py-madvr2.overridePythonAttrs (oldAttrs: rec {
        version = "1.6.40";
        src = fetchFromGitHub {
          owner = "iloveicedgreentea";
          repo = "py-madvr";
          tag = "v${version}";
          hash = "sha256-0IX57Sa/oXGiViD39FVBRa2jxuKuZ3UNsOTHwuBdmWs=";
        };
        pythonImportsCheck = [ "madvr" ];
        disabledTests = oldAttrs.disabledTests ++ [
          "test_async_add_tasks"
          "test_send_heartbeat"
        ];
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

      pysnooz = super.pysnooz.overridePythonAttrs (oldAttrs: rec {
        version = "0.8.6";
        src = fetchFromGitHub {
          owner = "AustinBrunkhorst";
          repo = "pysnooz";
          rev = "refs/tags/v${version}";
          hash = "sha256-hJwIObiuFEAVhgZXYB9VCeAlewBBnk0oMkP83MUCpyU=";
        };
        patches = [ ];
        doCheck = false;
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

      python-telegram-bot = super.python-telegram-bot.overridePythonAttrs (oldAttrs: rec {
        version = "21.5";

        src = fetchFromGitHub {
          inherit (oldAttrs.src) owner repo;
          tag = version;
          hash = "sha256-i1YEcN615xeI4HcygXV9kzuXpT2yDSnlNU6bZqu1dPM=";
        };
      });

      pytraccar = super.pytraccar.overridePythonAttrs (oldAttrs: rec {
        version = "2.1.1";

        src = fetchFromGitHub {
          inherit (oldAttrs.src) owner repo;
          tag = version;
          hash = "sha256-WTRqYw66iD4bbb1aWJfBI67+DtE1FE4oiuUKpfVqypE=";
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

      wolf-comm = super.wolf-comm.overridePythonAttrs rec {
        version = "0.0.23";
        src = fetchFromGitHub {
          owner = "janrothkegel";
          repo = "wolf-comm";
          tag = version;
          hash = "sha256-LpehooW3vmohiyMwOQTFNLiNCsaLKelWQxQk8bl+y1k=";
        };
      };

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
  hassVersion = "2025.10.3";

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
    hash = "sha256-b4yNS1uNoZSnTpYr3bVvSru/2KUe2d/xfe1tiAWibCg=";
  };

  # Secondary source is pypi sdist for translations
  sdist = fetchPypi {
    inherit pname version;
    hash = "sha256-BjPva2mxlArG9yDnk9PpjpdLiL2MA4Eeb8AP1nkoqKk=";
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
    ];

  pytestFlags = [
    # assign tests grouped by file to workers
    "--dist=loadfile"
    # enable full variable printing on error
    "--showlocals"
  ];

  enabledTestPaths = [
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
    # AssertionError: assert 1 == 0
    "tests/test_config.py::test_merge"
    # checks whether pip is installed
    "tests/util/test_package.py::test_check_package_fragment"
    # flaky
    "tests/test_bootstrap.py::test_setup_hass_takes_longer_than_log_slow_startup"
    "tests/test_test_fixtures.py::test_evict_faked_translations"
    "tests/helpers/test_backup.py::test_async_get_manager"
    # (2025.9.0) Extra argument (demo platform) in list that is expected to be empty
    "tests/scripts/test_check_config.py::test_config_platform_valid"
    # (2025.9.0) Schema mismatch, diff shows a required field that needs to be removed
    "tests/test_data_entry_flow.py::test_section_in_serializer"
    # (2025.9.0) unique id collision in async_update_entry
    "tests/test_config_entries.py::test_async_update_entry_unique_id_collision"
  ];

  preCheck = ''
    export HOME="$TEMPDIR"
    export PYTHONASYNCIODEBUG=1

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
