{ lib, stdenv, fetchFromGitHub, python3, openssl, cargo, rustPlatform, rustc
, enableSystemd ? lib.meta.availableOn stdenv.hostPlatform python3.pkgs.systemd
, nixosTests
, enableRedis ? true
, callPackage
}:

let
  plugins = python3.pkgs.callPackage ./plugins { };
  tools = callPackage ./tools { };
in
with python3.pkgs;
buildPythonApplication rec {
  pname = "matrix-synapse";
  version = "1.86.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "matrix-org";
    repo = "synapse";
    rev = "v${version}";
    hash = "sha256-vSNAISWTTT3IAeA8hxQhQNp9T3soey4vgh7v+BxI+K0=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-lPLhh5FkxpBUQ5UH6eAfUIyGvHIcZHmbYBT5QUW/W4k=";
  };

  postPatch = ''
    # Remove setuptools_rust from runtime dependencies
    # https://github.com/matrix-org/synapse/blob/v1.69.0/pyproject.toml#L177-L185
    sed -i '/^setuptools_rust =/d' pyproject.toml
  '';

  nativeBuildInputs = [
    poetry-core
    rustPlatform.cargoSetupHook
    setuptools-rust
    cargo
    rustc
  ];

  buildInputs = [ openssl ];

  propagatedBuildInputs = [
    authlib
    bcrypt
    bleach
    canonicaljson
    daemonize
    ijson
    immutabledict
    jinja2
    jsonschema
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
    signedjson
    sortedcontainers
    treq
    twisted
    typing-extensions
    unpaddedbase64
  ] ++ lib.optional enableSystemd systemd
    ++ lib.optionals enableRedis [ hiredis txredisapi ];

  nativeCheckInputs = [ mock parameterized openssl ];

  doCheck = !stdenv.isDarwin;

  checkPhase = let testFlags = lib.optionalString (!stdenv.isAarch64) "-j $NIX_BUILD_CORES"; in ''
    runHook preCheck

    # remove src module, so tests use the installed module instead
    rm -rf ./synapse

    PYTHONPATH=".:$PYTHONPATH" ${python3.interpreter} -m twisted.trial ${testFlags} tests

    runHook postCheck
  '';

  passthru.tests = { inherit (nixosTests) matrix-synapse; };
  passthru.plugins = plugins;
  passthru.tools = tools;
  passthru.python = python3;

  meta = with lib; {
    homepage = "https://matrix.org";
    description = "Matrix reference homeserver";
    license = licenses.asl20;
    maintainers = teams.matrix.members;
  };
}
