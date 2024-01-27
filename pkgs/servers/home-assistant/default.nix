{ stdenv
, lib
, callPackage
, fetchFromGitHub
, fetchPypi
, fetchpatch
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
      aiogithubapi = super.aiogithubapi.overridePythonAttrs (oldAttrs: rec {
        version = "22.10.1";
        src = fetchFromGitHub {
          owner = "ludeeus";
          repo = "aiogithubapi";
          rev = "refs/tags/${version}";
          hash = "sha256-ceBuqaMqqL6qwN52765MG4sLt+08hx2G9rUVNC7x6ik=";
        };
        propagatedBuildInputs = with self; [
          aiohttp
          async-timeout
          backoff
        ];
      });

      aionotion = super.aionotion.overridePythonAttrs (oldAttrs: rec {
        version = "2023.05.5";
        src = fetchFromGitHub {
          owner = "bachya";
          repo = "aionotion";
          rev = "refs/tags/${version}";
          hash = "sha256-/2sF8m5R8YXkP89bi5zR3h13r5LrFOl1OsixAcX0D4o=";
        };
        patches = [
          (fetchpatch {
            # clean up build dependencies; https://github.com/bachya/aionotion/commit/53c7285110d12810f9b43284295f71d052a81b83
            url = "https://github.com/bachya/aionotion/commit/53c7285110d12810f9b43284295f71d052a81b83.patch";
            hash = "sha256-RLRbHmaR2A8MNc96WHx0L8ccyygoBUaOulAuRJkFuUM=";
          })
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
          substituteInPlace pyproject.toml --replace \
            '"setuptools >= 35.0.2", "wheel >= 0.29.0", "poetry>=0.12"' \
            '"poetry-core"'
        '';
      });

      aiopvapi = super.aiopvapi.overridePythonAttrs (oldAttrs: rec {
        version = "2.0.4";
        src = fetchFromGitHub {
          owner = "sander76";
          repo = "aio-powerview-api";
          rev = "refs/tags/v${version}";
          hash = "sha256-cghfNi5T343/7GxNLDrE0iAewMlRMycQTP7SvDVpU2M=";
        };
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
          substituteInPlace pyproject.toml --replace \
            '"setuptools >= 35.0.2", "wheel >= 0.29.0", "poetry>=0.12"' \
            '"poetry-core"'
        '';
      });

      amberelectric = super.amberelectric.overridePythonAttrs (oldAttrs: rec {
        version = "1.0.4";
        src = fetchPypi {
          inherit (oldAttrs) pname;
          inherit version;
          hash = "sha256-5SWJnTxRm6mzP0RxrgA+jnV+Gp23WjqQA57wbT2V9Dk=";
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
        nativeBuildInputs = with self; [
          setuptools
        ];
        propagatedBuildInputs = with self; [
          aenum
          aiohttp
          pydantic
          requests
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

      pydrawise = super.pydrawise.overridePythonAttrs (oldAttrs: rec {
        version = "2023.11.0";
        src = fetchFromGitHub {
          owner = "dknowles2";
          repo = "pydrawise";
          rev = "refs/tags/${version}";
          hash = "sha256-gKOyTvdETGzKlpU67UKaHYTIvnAX9znHIynP3BiVbt4=";
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

      python-kasa = super.python-kasa.overridePythonAttrs (oldAttrs: rec {
        version = "0.5.4";
        src = fetchFromGitHub {
          owner = "python-kasa";
          repo = "python-kasa";
          rev = "refs/tags/${version}";
          hash = "sha256-wGPMrYaTtKkkNW88eyiiciFcBSTRqqChYi6e15WUCHo=";
        };
      });

      python-roborock = super.python-roborock.overridePythonAttrs (oldAttrs: rec {
        version = "0.38.0";
        src = fetchFromGitHub {
          owner = "humbertogontijo";
          repo = "python-roborock";
          rev = "refs/tags/v${version}";
          hash = "sha256-jYESUMhLb5oiM3PWIIIU4dn/waGUnCAaXe0URnIq0C8=";
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

      tesla-powerwall = super.tesla-powerwall.overridePythonAttrs (oldAttrs: rec {
        version = "0.3.19";
        src = fetchFromGitHub {
          owner = "jrester";
          repo = "tesla_powerwall";
          rev = "refs/tags/v${version}";
          hash = "sha256-ClrMgPAMBtDMfD6hCJIN1u4mp75QW+c3re28v3FreQg=";
        };
      });

      versioningit = super.versioningit.overridePythonAttrs (oldAttrs: rec {
        version = "2.2.0";
        src = fetchPypi {
          inherit (oldAttrs) pname;
          inherit version;
          hash = "sha256-6xjnunJoqIC/HM/pLlNOlqs04Dl/KNy8s/wNpPaltr0=";
        };
      });

      voluptuous = super.voluptuous.overridePythonAttrs (oldAttrs: rec {
        version = "0.13.1";
        src = fetchFromGitHub {
          owner = "alecthomas";
          repo = "voluptuous";
          rev = "refs/tags/${version}";
          hash = "sha256-cz3Bd+/yPh+VOHxzi/W+gbDh/H5Nl/n4jvxDOirmAVk=";
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
  hassVersion = "2024.1.5";

in python.pkgs.buildPythonApplication rec {
  pname = "homeassistant";
  version = assert (componentPackages.version == hassVersion); hassVersion;
  format = "pyproject";

  # check REQUIRED_PYTHON_VER in homeassistant/const.py
  disabled = python.pythonOlder "3.11";

  # don't try and fail to strip 6600+ python files, it takes minutes!
  dontStrip = true;

  # Primary source is the git, which has the tests and allows bisecting the core
  src = fetchFromGitHub {
    owner = "home-assistant";
    repo = "core";
    rev = "refs/tags/${version}";
    hash = "sha256-6HPHoUpS2WXbYx7Tbqp9LLo25DyNzNd/THpSo7Y43Jw=";
  };

  # Secondary source is pypi sdist for translations
  sdist = fetchPypi {
    inherit pname version;
    hash = "sha256-cptN6NgB/1qnvz+/EqDBQiH2vSQsOeSljSVFZBFXR5Y=";
  };

  nativeBuildInputs = with python.pkgs; [
    pythonRelaxDepsHook
    setuptools
  ];

  pythonRelaxDeps = [
    "awesomeversion"
    "ciso8601"
    "cryptography"
    "home-assistant-bluetooth"
    "httpx"
    "jinja2"
    "lru-dict"
    "orjson"
    "pyopenssl"
    "typing-extensions"
    "urllib3"
    "voluptuous"
    "yarl"
  ];

  # extract translations from pypi sdist
  prePatch = ''
    tar --extract --gzip --file $sdist --strip-components 1 --wildcards "**/translations"
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

  postPatch = ''
    substituteInPlace tests/test_config.py --replace '"/usr"' '"/build/media"'

    sed -i 's/setuptools[~=]/setuptools>/' pyproject.toml
    sed -i 's/wheel[~=]/wheel>/' pyproject.toml
  '';

  propagatedBuildInputs = with python.pkgs; [
    # Only packages required in pyproject.toml
    aiohttp
    aiohttp-cors
    aiohttp-fast-url-dispatcher
    aiohttp-zlib-ng
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
    # REQUIREMENTS in homeassistant/auth/mfa_modules/totp.py and homeassistant/auth/mfa_modules/notify.py
    pyotp
    pyqrcode
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
    # Sneakily imported in tests/conftest.py
    paho-mqtt
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
    # AssertionError: assert 'WARNING' not in '2023-11-10 ...nt abc[L]>\n'"
    "--deselect=tests/helpers/test_script.py::test_multiple_runs_repeat_choose"
    # SystemError: PyThreadState_SetAsyncExc failed
    "--deselect=tests/helpers/test_template.py::test_template_timeout"
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
    mainProgram = "hass";
  };
}
