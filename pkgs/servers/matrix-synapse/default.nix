{ lib, stdenv, fetchFromGitHub, python3, openssl, rustPlatform
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
  version = "1.80.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "matrix-org";
    repo = "synapse";
    rev = "v${version}";
    hash = "sha256-Lw6gmuI+ntOW54HQbmDoY9QYNDTu5vgtrJz6HMWWmMM=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-KqPpaIJ8VuVV6f6n14/7wbA+Vtk7NvWm09bUBWuAAlY=";
  };

  postPatch = ''
    # Remove setuptools_rust from runtime dependencies
    # https://github.com/matrix-org/synapse/blob/v1.69.0/pyproject.toml#L177-L185
    sed -i '/^setuptools_rust =/d' pyproject.toml
    sed -i 's/^frozendict = ">=1,!=2.1.2,<2.3.5"/frozendict = ">=1,!=2.1.2,<2.3.6"/g' pyproject.toml
  '';

  nativeBuildInputs = [
    poetry-core
    rustPlatform.cargoSetupHook
    setuptools-rust
  ] ++ (with rustPlatform.rust; [
    cargo
    rustc
  ]);

  buildInputs = [ openssl ];

  propagatedBuildInputs = [
    authlib
    bcrypt
    bleach
    canonicaljson
    daemonize
    frozendict
    ijson
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

  checkPhase = ''
    runHook preCheck

    # remove src module, so tests use the installed module instead
    rm -rf ./synapse

    PYTHONPATH=".:$PYTHONPATH" ${python3.interpreter} -m twisted.trial -j $NIX_BUILD_CORES tests

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
