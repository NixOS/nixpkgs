{ lib, stdenv, fetchFromGitHub, python3, openssl, rustPlatform
, enableSystemd ? stdenv.isLinux, nixosTests
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
  version = "1.69.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "matrix-org";
    repo = "synapse";
    rev = "v${version}";
    hash = "sha256-Epzvxy3w8Xdj8xz8GEry97J7zGudIgjUH51NcibKDvQ=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-RJq4mdPtnAR45rAycGDSSuvZwkJPOiqFBp+8mnBTKvU=";
  };

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
    pyjwt
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

  checkInputs = [ mock parameterized openssl ];

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
