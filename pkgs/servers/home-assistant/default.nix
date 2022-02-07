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

# Override Python packages using
# self: super: { pkg = super.pkg.overridePythonAttrs (oldAttrs: { ... }); }
# Applied after defaultOverrides
, packageOverrides ? self: super: {}

# Skip pip install of required packages on startup
, skipPip ? true }:

let
  defaultOverrides = [
    # Override the version of some packages pinned in Home Assistant's setup.py and requirements_all.txt
    (mkOverride "python-slugify" "4.0.1" "69a517766e00c1268e5bbfc0d010a0a8508de0b18d30ad5a1ff357f8ae724270")

    (self: super: {
      huawei-lte-api = super.huawei-lte-api.overridePythonAttrs (oldAttrs: rec {
        version = "1.4.18";
        src = fetchFromGitHub {
          owner = "Salamek";
          repo = "huawei-lte-api";
          rev = version;
          sha256 = "1qaqxmh03j10wa9wqbwgc5r3ays8wfr7bldvsm45fycr3qfyn5fg";
        };
        propagatedBuildInputs = oldAttrs.propagatedBuildInputs ++ [ python3.pkgs.dicttoxml ];
      });
    })

    # Pinned due to API changes in pyruckus>0.12
    (self: super: {
      pyruckus = super.pyruckus.overridePythonAttrs (oldAttrs: rec {
        version = "0.12";
        src = fetchFromGitHub {
          owner = "gabe565";
          repo = "pyruckus";
          rev = version;
          sha256 = "0ykv6r6blbj3fg9fplk9i7xclkv5d93rwvx0fm5s8ms9f2s9ih8z";
        };
      });
    })

    # Pinned due to API changes in 0.1.0
    (mkOverride "poolsense" "0.0.8" "09y4fq0gdvgkfsykpxnvmfv92dpbknnq5v82spz43ak6hjnhgcyp")

    # Requirements for recorder not found: ['sqlalchemy==1.4.27'].
    #(mkOverride "sqlalchemy" "1.4.27" "031jbd0svrvwr3n52iibp9mkwsj9wicnck45yd26da5kmsfkas6p")

    # Pinned due to API changes in 0.4.0
    (self: super: {
      vilfo-api-client = super.vilfo-api-client.overridePythonAttrs (oldAttrs: rec {
        version = "0.3.3";
        src = fetchFromGitHub {
          owner = "ManneW";
          repo = "vilfo-api-client-python";
          rev = "v$version}";
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

  mkOverride = attrname: version: sha256:
    self: super: {
      ${attrname} = super.${attrname}.overridePythonAttrs (oldAttrs: {
        inherit version;
        src = oldAttrs.src.override {
          inherit version sha256;
        };
      });
    };

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

  # Don't forget to run parse-requirements.py after updating
  hassVersion = "2022.2.3";

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
    hash = "sha256:OqyWm7O8ajxBlWGzvNhZvFmy5p2dINfMQ3cQ304Er18=";
  };

  # leave this in, so users don't have to constantly update their downstream patch handling
  patches = [
    (substituteAll {
      src = ./patches/ffmpeg-path.patch;
      ffmpeg = "${lib.getBin ffmpeg}/bin/ffmpeg";
    })
    ./patches/tests-ignore-OSErrors-in-hass-fixture.patch
  ];

  postPatch = let
    relaxedConstraints = [
      "aiohttp"
      "async_timeout"
      "attrs"
      "awesomeversion"
      "bcrypt"
      "cryptography"
      "httpx"
      "pip"
      "PyJWT"
      "requests"
      "yarl"
    ];
  in ''
    sed -r -i \
      ${lib.concatStringsSep "\n" (map (package:
        ''-e 's@${package}[<>=]+.*@${package}@g' \''
      ) relaxedConstraints)}
    setup.cfg
    substituteInPlace tests/test_config.py --replace '"/usr"' '"/build/media"'
  '';

  propagatedBuildInputs = with python.pkgs; [
    # Only packages required in setup.py
    aiohttp
    astral
    async-timeout
    atomicwrites
    attrs
    awesomeversion
    bcrypt
    certifi
    ciso8601
    cryptography
    httpx
    ifaddr
    jinja2
    pip
    pyjwt
    python-slugify
    pytz
    pyyaml
    requests
    ruamel-yaml
    voluptuous
    voluptuous-serialize
    yarl
    # Not in setup.py, but used in homeassistant/util/package.py
    setuptools
  ] ++ componentBuildInputs ++ extraBuildInputs;

  makeWrapperArgs = lib.optional skipPip "--add-flags --skip-pip";

  # upstream only tests on Linux, so do we.
  doCheck = stdenv.isLinux;

  checkInputs = with python.pkgs; [
    # test infrastructure (selectively from requirement_test.txt)
    freezegun
    jsonpickle
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
    tqdm
    # required by tests/pylint
    astroid
    pylint
    # required by tests/auth/mfa_modules
    pyotp
  ] ++ lib.concatMap (component: getPackages component python.pkgs) [
    # some components are needed even if tests in tests/components are disabled
    "default_config"
    "hue"
  ];

  pytestFlagsArray = [
    # parallelize test run
    "--numprocesses $NIX_BUILD_CORES"
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
