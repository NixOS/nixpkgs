{ stdenv
, lib
, callPackage
, fetchFromGitHub
, fetchPypi
, python312
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

      aiopurpleair = super.aiopurpleair.overridePythonAttrs (oldAttrs: rec {
        version = "2022.12.1";
        src = fetchFromGitHub {
          owner = "bachya";
          repo = "aiopurpleair";
          rev = "refs/tags/${version}";
          hash = "sha256-YmJH4brWkTpgzyHwu9UnIWrY5qlDCmMtvF+KxQFXwfk=";
        };
        postPatch = ''
          substituteInPlace pyproject.toml --replace-fail \
            '"setuptools >= 35.0.2", "wheel >= 0.29.0", "poetry>=0.12"' \
            '"poetry-core"'
        '';
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

      openhomedevice = super.openhomedevice.overridePythonAttrs (oldAttrs: rec {
        version = "2.2";
        src = fetchFromGitHub {
          inherit (oldAttrs.src) owner repo;
          rev = "refs/tags/${version}";
          hash = "sha256-GGp7nKFH01m1KW6yMkKlAdd26bDi8JDWva6OQ0CWMIw=";
        };
      });

      pymelcloud = super.pymelcloud.overridePythonAttrs (oldAttrs: {
        version = "2.5.9";
        src = fetchFromGitHub {
          owner = "vilppuvuorinen";
          repo = "pymelcloud";
          rev = "33a827b6cd0b34f276790faa49bfd0994bb7c2e4"; # 2.5.x branch
          sha256 = "sha256-Q3FIo9YJwtWPHfukEBjBANUQ1N1vr/DMnl1dgiN7vYg=";
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

      # Pinned due to API changes in 0.1.0
      poolsense = super.poolsense.overridePythonAttrs (oldAttrs: rec {
        version = "0.0.8";
        src = fetchPypi {
          pname = "poolsense";
          inherit version;
          hash = "sha256-17MHrYRmqkH+1QLtgq2d6zaRtqvb9ju9dvPt9gB2xCc=";
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

      pyaussiebb = super.pyaussiebb.overridePythonAttrs (oldAttrs: rec {
        version = "0.0.18";
        src = fetchFromGitHub {
          owner = "yaleman";
          repo = "aussiebb";
          rev = "refs/tags/v${version}";
          hash = "sha256-tEdddVsLFCHRvyLCctDakioiop2xWaJlfGE16P1ukHc=";
        };
      });

      pydantic = super.pydantic_1;

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
        dependencies = oldAttrs.propagatedBuildInputs or [] ++ [
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
      });

      # newer sigstore version transitivevly require pydantic>=2
      sigstore = super.sigstore.overridePythonAttrs (oldAttrs: rec {
        version = "1.1.2";
        src = fetchFromGitHub {
          owner = "sigstore";
          repo = "sigstore-python";
          rev = "refs/tags/v${version}";
          hash = "sha256-QqY5GOBS75OkbSaF5Ua5jnJAhsYfVRuWLUoWDxX8Ino=";
        };
        dependencies = with self; [
          appdirs
          cryptography
          id
          pydantic
          pyjwt
          pyopenssl
          requests
          securesystemslib
          sigstore-protobuf-specs
          tuf
        ];
        doCheck = false; # pytest too new
      });

      sigstore-protobuf-specs = super.sigstore-protobuf-specs.overridePythonAttrs {
        version = "0.1.0";
        src = fetchPypi {
          pname = "sigstore-protobuf-specs";
          version = "0.1.0";
          hash = "sha256-YistIxYToo7T5mYKzYeBhnW06DSG9JoPDBmKxUdfy4E=";
        };
        nativeBuildInputs = with self; [
          flit-core
        ];
        pythonRelaxDeps = [
          "betterproto"
        ];
      };

      slack-sdk = super.slack-sdk.overridePythonAttrs (oldAttrs: rec {
        version = "2.5.0";
        src = fetchFromGitHub {
          owner = "slackapi";
          repo = "python-slackclient";
          rev = "refs/tags/${version}";
          hash = "sha256-U//HUe6e41wOOzoaDl4yXPnEASCzpGBIScHStWMN8tk=";
        };
        postPatch = ''
          substituteInPlace setup.py \
            --replace-fail "pytest-runner" ""
        '';
        pythonImportsCheck = [ "slack" ];
        doCheck = false; # Tests changed a lot for > 3
      });

      tuf = super.tuf.overridePythonAttrs rec {
        version = "2.1.0";
        src = fetchFromGitHub {
          owner = "theupdateframework";
          repo = "python-tuf";
          rev = "refs/tags/v${version}";
          hash = "sha256-MdPctAZuKn/YAwpMJ5gWU7PXJD3iK7bYprLXV52wNQQ=";
        };
        disabledTests = [
          "test_sign_failures"
        ];
      };

      versioningit = super.versioningit.overridePythonAttrs {
        doCheck = false;
      };

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

      xbox-webapi = super.xbox-webapi.overridePythonAttrs (oldAttrs: rec {
        version = "2.0.11";
        src = fetchFromGitHub {
          owner = "OpenXbox";
          repo = "xbox-webapi-python";
          rev = "refs/tags/v${version}";
          hash = "sha256-fzMB+I8+ZTJUiZovcuj+d5GdHY9BJyJd6j92EhJeIFI=";
        };
        postPatch = ''
          sed -i '/pytest-runner/d' setup.py
        '';
        propagatedBuildInputs = with self; [
          aiohttp
          appdirs
          ms-cv
          pydantic
          ecdsa
        ];
        nativeCheckInputs = with self; [
          aresponses
        ];
      });

      youtubeaio = super.youtubeaio.overridePythonAttrs (old: {
        pytestFlagsArray = [
          # fails with pydantic v1
          "--deselect=tests/test_video.py::test_fetch_video"
        ];
      });

      # internal python packages only consumed by home-assistant itself
      home-assistant-frontend = self.callPackage ./frontend.nix { };
      home-assistant-intents = self.callPackage ./intents.nix { };
      homeassistant = self.toPythonModule home-assistant;
      pytest-homeassistant-custom-component = self.callPackage ./pytest-homeassistant-custom-component.nix { };
    })
  ];

  python = python312.override {
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
  hassVersion = "2024.9.3";

in python.pkgs.buildPythonApplication rec {
  pname = "homeassistant";
  version = assert (componentPackages.version == hassVersion); hassVersion;
  pyproject = true;

  # check REQUIRED_PYTHON_VER in homeassistant/const.py
  disabled = python.pythonOlder "3.11";

  # don't try and fail to strip 6600+ python files, it takes minutes!
  dontStrip = true;

  # Primary source is the git, which has the tests and allows bisecting the core
  src = fetchFromGitHub {
    owner = "home-assistant";
    repo = "core";
    rev = "refs/tags/${version}";
    hash = "sha256-W/qngUrc/R3lqdIWUFIXtP9IJ6t+VGdeAdJyZuGm94Q=";
  };

  # Secondary source is pypi sdist for translations
  sdist = fetchPypi {
    inherit pname version;
    hash = "sha256-Qp1AiB89sq1OrAVR7qLEfX1j8kW8L2lb4Z1x4z4AzP0=";
  };

  build-system = with python.pkgs; [
    setuptools
  ];

  pythonRelaxDeps = [
    "aiohttp"
    "attrs"
    "bcrypt"
    "ciso8601"
    "cryptography"
    "jinja2"
    "hass-nabucasa"
    "httpx"
    "orjson"
    "pillow"
    "pyjwt"
    "pyopenssl"
    "pyyaml"
    "requests"
    "sqlalchemy"
    "typing-extensions"
    "urllib3"
    "yarl"
  ];

  # extract translations from pypi sdist
  prePatch = ''
    tar --extract --gzip --file $sdist --strip-components 1 --wildcards "**/translations"
  '';

  # leave this in, so users don't have to constantly update their downstream patch handling
  patches = [
    # Follow symlinks in /var/lib/hass/www
    ./patches/static-follow-symlinks.patch

    # Patch path to ffmpeg binary
    (substituteAll {
      src = ./patches/ffmpeg-path.patch;
      ffmpeg = "${lib.getExe ffmpeg-headless}";
    })
  ];

  postPatch = ''
    substituteInPlace tests/test_config.py --replace-fail '"/usr"' "\"$NIX_BUILD_TOP/media\""

    substituteInPlace pyproject.toml --replace-fail "wheel~=0.43.0" wheel

    sed -i 's/setuptools[~=]/setuptools>/' pyproject.toml
    sed -i 's/wheel[~=]/wheel>/' pyproject.toml
  '';

  dependencies = with python.pkgs; [
    # Only packages required in pyproject.toml
    aiodns
    aiohttp
    aiohttp-cors
    aiohttp-fast-zlib
    aiozoneinfo
    astral
    async-interrupt
    atomicwrites-homeassistant
    attrs
    awesomeversion
    bcrypt
    certifi
    ciso8601
    cryptography
    fnv-hash-fast
    hass-nabucasa
    home-assistant-bluetooth
    httpx
    ifaddr
    jinja2
    lru-dict
    orjson
    packaging
    pillow
    pip
    psutil-home-assistant
    pyjwt
    pyopenssl
    python-slugify
    pyyaml
    requests
    sqlalchemy
    typing-extensions
    ulid-transform
    urllib3
    voluptuous
    voluptuous-openapi
    voluptuous-serialize
    yarl
    # REQUIREMENTS in homeassistant/auth/mfa_modules/totp.py and homeassistant/auth/mfa_modules/notify.py
    pyotp
    pyqrcode
    # Implicit dependency via homeassistant/requirements.py
    packaging
  ];

  makeWrapperArgs = lib.optional skipPip "--add-flags --skip-pip";

  # upstream only tests on Linux, so do we.
  doCheck = stdenv.hostPlatform.isLinux;

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
    # Sneakily imported in tests/conftest.py
    paho-mqtt
    # Used in tests/non_packaged_scripts/test_alexa_locales.py
    beautifulsoup4
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
    # AssertionError: assert 1 == 0
    "--deselect tests/test_config.py::test_merge"
    # AssertionError: assert 6 == 5
    "--deselect=tests/helpers/test_translation.py::test_caching"
    # assert "Detected that integration 'hue' attempted to create an asyncio task from a thread at homeassistant/components/hue/light.py, line 23
    "--deselect=tests/util/test_async.py::test_create_eager_task_from_thread_in_integration"
    # Services were renamed to Actions in language strings, but the tests are lagging behind
    "--deselect=tests/test_core.py::test_serviceregistry_service_that_not_exists"
    "--deselect=tests/test_core.py::test_services_call_return_response_requires_blocking"
    "--deselect=tests/test_core.py::test_serviceregistry_return_response_arguments"
    "--deselect=tests/helpers/test_script.py::test_parallel_error"
    "--deselect=tests/helpers/test_script.py::test_propagate_error_service_not_found"
    "--deselect=tests/helpers/test_script.py::test_continue_on_error_automation_issue"
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
      withoutCheckDeps = home-assistant.overridePythonAttrs {
        pname = "home-assistant-without-check-deps";
        doCheck = false;
      };
    };
  };

  meta = with lib; {
    homepage = "https://home-assistant.io/";
    description = "Open source home automation that puts local control and privacy first";
    license = licenses.asl20;
    maintainers = teams.home-assistant.members;
    platforms = platforms.linux;
    mainProgram = "hass";
  };
}
