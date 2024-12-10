{
  lib,
  stdenv,
  fetchFromGitHub,
  python3,
  openssl,
  libiconv,
  cargo,
  rustPlatform,
  rustc,
  nixosTests,
  callPackage,
}:

let
  plugins = python3.pkgs.callPackage ./plugins { };
  tools = callPackage ./tools { };
in
python3.pkgs.buildPythonApplication rec {
  pname = "matrix-synapse";
  version = "1.120.2";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "element-hq";
    repo = "synapse";
    rev = "v${version}";
    hash = "sha256-GW5ZcrVLLR2dPADHasdqhtV8HF+X+N4W3/OZCFBd2uI=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-5x64eKFuiTWuzwbuhfJ38rksYowq9Nq3LTYCMwuXKzc=";
  };

  postPatch = ''
    # Remove setuptools_rust from runtime dependencies
    # https://github.com/element-hq/synapse/blob/v1.69.0/pyproject.toml#L177-L185
    sed -i '/^setuptools_rust =/d' pyproject.toml

    # Remove version pin on build dependencies. Upstream does this on purpose to
    # be extra defensive, but we don't want to deal with updating this
    sed -i 's/"poetry-core>=\([0-9.]*\),<=[0-9.]*"/"poetry-core>=\1"/' pyproject.toml
    sed -i 's/"setuptools_rust>=\([0-9.]*\),<=[0-9.]*"/"setuptools_rust>=\1"/' pyproject.toml

    # Don't force pillow to be 10.0.1 because we already have patched it, and
    # we don't use the pillow wheels.
    sed -i 's/Pillow = ".*"/Pillow = ">=5.4.0"/' pyproject.toml
  '';

  nativeBuildInputs = with python3.pkgs; [
    poetry-core
    rustPlatform.cargoSetupHook
    setuptools-rust
    cargo
    rustc
  ];

  buildInputs =
    [
      openssl
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      libiconv
    ];

  propagatedBuildInputs =
    with python3.pkgs;
    [
      attrs
      bcrypt
      bleach
      canonicaljson
      cryptography
      ijson
      immutabledict
      jinja2
      jsonschema
      matrix-common
      msgpack
      python-multipart
      netaddr
      packaging
      phonenumbers
      pillow
      prometheus-client
      pyasn1
      pyasn1-modules
      pydantic
      pymacaroons
      pyopenssl
      pyyaml
      service-identity
      signedjson
      sortedcontainers
      treq
      twisted
      typing-extensions
      unpaddedbase64
    ]
    ++ twisted.optional-dependencies.tls;

  optional-dependencies = with python3.pkgs; {
    postgres =
      if isPyPy then
        [
          psycopg2cffi
        ]
      else
        [
          psycopg2
        ];
    saml2 = [
      pysaml2
    ];
    oidc = [
      authlib
    ];
    systemd = [
      systemd
    ];
    url-preview = [
      lxml
    ];
    sentry = [
      sentry-sdk
    ];
    jwt = [
      authlib
    ];
    redis = [
      hiredis
      txredisapi
    ];
    cache-memory = [
      pympler
    ];
    user-search = [
      pyicu
    ];
  };

  nativeCheckInputs =
    [
      openssl
    ]
    ++ (with python3.pkgs; [
      mock
      parameterized
    ])
    ++ lib.flatten (lib.attrValues optional-dependencies);

  doCheck = !stdenv.hostPlatform.isDarwin;

  checkPhase = ''
    runHook preCheck

    # remove src module, so tests use the installed module instead
    rm -rf ./synapse

    # high parallelisem makes test suite unstable
    # upstream uses 2 cores but 4 seems to be also stable
    # https://github.com/element-hq/synapse/blob/develop/.github/workflows/latest_deps.yml#L103
    if (( $NIX_BUILD_CORES > 4)); then
      NIX_BUILD_CORES=4
    fi

    PYTHONPATH=".:$PYTHONPATH" ${python3.interpreter} -m twisted.trial -j $NIX_BUILD_CORES tests

    runHook postCheck
  '';

  passthru = {
    tests = { inherit (nixosTests) matrix-synapse matrix-synapse-workers; };
    inherit plugins tools;
    python = python3;
  };

  meta = with lib; {
    homepage = "https://matrix.org";
    changelog = "https://github.com/element-hq/synapse/releases/tag/v${version}";
    description = "Matrix reference homeserver";
    license = licenses.agpl3Plus;
    maintainers = teams.matrix.members;
  };
}
