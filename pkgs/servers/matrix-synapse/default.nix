<<<<<<< HEAD
{ lib
, stdenv
, fetchFromGitHub
, python3
, openssl
, cargo
, rustPlatform
, rustc
, nixosTests
=======
{ lib, stdenv, fetchFromGitHub, python3, openssl, cargo, rustPlatform, rustc
, enableSystemd ? lib.meta.availableOn stdenv.hostPlatform python3.pkgs.systemd
, nixosTests
, enableRedis ? true
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, callPackage
}:

let
  plugins = python3.pkgs.callPackage ./plugins { };
  tools = callPackage ./tools { };
in
<<<<<<< HEAD
python3.pkgs.buildPythonApplication rec {
  pname = "matrix-synapse";
  version = "1.92.1";
=======
with python3.pkgs;
buildPythonApplication rec {
  pname = "matrix-synapse";
  version = "1.83.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "matrix-org";
    repo = "synapse";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-rCxoYtdvh+Gu0O2T3uu0k2FFFFc7m09LuKJvkSky3M4=";
=======
    hash = "sha256-7LMNLXTBkY7ib9DWpwccVrHxulUW8ScFr37hSGO72GM=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
<<<<<<< HEAD
    hash = "sha256-yZeCENWdPv80Na1++/IQFOrhah/VHWwJDNV2dI/yTHg=";
=======
    hash = "sha256-tzkJtkAbZ9HmOQq2O7QAbRb5pYS/WoU3k1BJhZAE6OU=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  postPatch = ''
    # Remove setuptools_rust from runtime dependencies
    # https://github.com/matrix-org/synapse/blob/v1.69.0/pyproject.toml#L177-L185
    sed -i '/^setuptools_rust =/d' pyproject.toml
<<<<<<< HEAD

    # Remove version pin on build dependencies. Upstream does this on purpose to
    # be extra defensive, but we don't want to deal with updating this
    sed -i 's/"poetry-core>=\([0-9.]*\),<=[0-9.]*"/"poetry-core>=\1"/' pyproject.toml
    sed -i 's/"setuptools_rust>=\([0-9.]*\),<=[0-9.]*"/"setuptools_rust>=\1"/' pyproject.toml
  '';

  nativeBuildInputs = with python3.pkgs; [
=======
  '';

  nativeBuildInputs = [
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    poetry-core
    rustPlatform.cargoSetupHook
    setuptools-rust
    cargo
    rustc
  ];

<<<<<<< HEAD
  buildInputs = [
    openssl
  ];

  propagatedBuildInputs = with python3.pkgs; [
    attrs
    bcrypt
    bleach
    canonicaljson
    cryptography
=======
  buildInputs = [ openssl ];

  propagatedBuildInputs = [
    authlib
    bcrypt
    bleach
    canonicaljson
    daemonize
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    ijson
    immutabledict
    jinja2
    jsonschema
<<<<<<< HEAD
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
=======
    lxml
    matrix-common
    msgpack
    netaddr
    phonenumbers
    pillow
    prometheus-client
    psutil
    psycopg2
    pyasn1
    pydantic
    pyicu
    pymacaroons
    pynacl
    pyopenssl
    pysaml2
    pyyaml
    requests
    setuptools
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    signedjson
    sortedcontainers
    treq
    twisted
    typing-extensions
    unpaddedbase64
<<<<<<< HEAD
  ]
  ++ twisted.optional-dependencies.tls;

  passthru.optional-dependencies = with python3.pkgs; {
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
    opentracing = [
      jaeger-client
      opentracing
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
  ] ++ (with python3.pkgs; [
    mock
    parameterized
  ])
  ++ lib.flatten (lib.attrValues passthru.optional-dependencies);
=======
  ] ++ lib.optional enableSystemd systemd
    ++ lib.optionals enableRedis [ hiredis txredisapi ];

  nativeCheckInputs = [ mock parameterized openssl ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  doCheck = !stdenv.isDarwin;

  checkPhase = ''
    runHook preCheck

    # remove src module, so tests use the installed module instead
    rm -rf ./synapse

<<<<<<< HEAD
    # high parallelisem makes test suite unstable
    # upstream uses 2 cores but 4 seems to be also stable
    # https://github.com/matrix-org/synapse/blob/develop/.github/workflows/latest_deps.yml#L103
    if (( $NIX_BUILD_CORES > 4)); then
      NIX_BUILD_CORES=4
    fi

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    PYTHONPATH=".:$PYTHONPATH" ${python3.interpreter} -m twisted.trial -j $NIX_BUILD_CORES tests

    runHook postCheck
  '';

<<<<<<< HEAD
  passthru = {
    tests = { inherit (nixosTests) matrix-synapse; };
    inherit plugins tools;
    python = python3;
  };

  meta = with lib; {
    homepage = "https://matrix.org";
    changelog = "https://github.com/matrix-org/synapse/releases/tag/v${version}";
=======
  passthru.tests = { inherit (nixosTests) matrix-synapse; };
  passthru.plugins = plugins;
  passthru.tools = tools;
  passthru.python = python3;

  meta = with lib; {
    homepage = "https://matrix.org";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    description = "Matrix reference homeserver";
    license = licenses.asl20;
    maintainers = teams.matrix.members;
  };
}
