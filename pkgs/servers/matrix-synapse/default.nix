{ lib
, stdenv
, fetchFromGitHub
, fetchPypi
, python3
, openssl
, libiconv
, cargo
, rustPlatform
, rustc
, nixosTests
, callPackage
}:

let
  python = python3.override {
    packageOverrides = self: super: {
      netaddr = super.netaddr.overridePythonAttrs (oldAttrs: rec {
        version = "1.0.0";

        src = fetchPypi {
          pname = "netaddr";
          inherit version;
          hash = "sha256-6wRrVTVOelv4AcBJAq6SO9aZGQJC2JsJnolvmycktNM=";
        };
      });
    };
  };

  plugins = python.pkgs.callPackage ./plugins { };
  tools = callPackage ./tools { };
in
python.pkgs.buildPythonApplication rec {
  pname = "matrix-synapse";
  version = "1.103.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "element-hq";
    repo = "synapse";
    rev = "v${version}";
    hash = "sha256-NwHX4pOM2PUf2MldaPTOzP9gOcTmILxM1Sx2HPkLBcw=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-AyV0JPPJkJ4jdaw0FUXPqGF3Qkce1+RK70FkXAw+bLA=";
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

  nativeBuildInputs = with python.pkgs; [
    poetry-core
    rustPlatform.cargoSetupHook
    setuptools-rust
    cargo
    rustc
  ];

  buildInputs = [
    openssl
  ] ++ lib.optionals stdenv.isDarwin [
    libiconv
  ];

  propagatedBuildInputs = with python.pkgs; [
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

  passthru.optional-dependencies = with python.pkgs; {
    postgres = if isPyPy then [
      psycopg2cffi
    ] else [
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

  nativeCheckInputs = [
    openssl
  ] ++ (with python.pkgs; [
    mock
    parameterized
  ])
  ++ lib.flatten (lib.attrValues passthru.optional-dependencies);

  doCheck = !stdenv.isDarwin;

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

    PYTHONPATH=".:$PYTHONPATH" ${python.interpreter} -m twisted.trial -j $NIX_BUILD_CORES tests

    runHook postCheck
  '';

  passthru = {
    tests = { inherit (nixosTests) matrix-synapse matrix-synapse-workers; };
    inherit plugins tools python;
  };

  meta = with lib; {
    homepage = "https://matrix.org";
    changelog = "https://github.com/element-hq/synapse/releases/tag/v${version}";
    description = "Matrix reference homeserver";
    license = licenses.agpl3Plus;
    maintainers = teams.matrix.members;
  };
}
