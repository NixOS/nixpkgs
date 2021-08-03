{ lib, stdenv, python3, openssl
, enableSystemd ? stdenv.isLinux, nixosTests
, enableRedis ? false
, callPackage
}:

with python3.pkgs;

let
  plugins = python3.pkgs.callPackage ./plugins { };
  tools = callPackage ./tools { };
in
buildPythonApplication rec {
  pname = "matrix-synapse";
  version = "1.40.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-5RCeKTAtuFERQSoz4WinGz36tMuKtijnupPR/X02hCU=";
  };

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
    msgpack
    netaddr
    phonenumbers
    pillow
    prometheus_client
    psutil
    psycopg2
    pyasn1
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
    ++ lib.optional enableRedis hiredis;

  checkInputs = [ mock parameterized openssl ];

  doCheck = !stdenv.isDarwin;

  checkPhase = ''
    PYTHONPATH=".:$PYTHONPATH" ${python3.interpreter} -m twisted.trial tests
  '';

  postFixup = ''
    mkdir -p $out/bin

    # Make a little wrapper for running Synapse with its dependencies
    echo "#!/bin/sh
      exec python -m synapse.app.homeserver \"\$@\"
    " > $out/bin/homeserver
    chmod +x $out/bin/homeserver
    wrapProgram $out/bin/homeserver \
      --set PATH ${python3}/bin \
      --set PYTHONPATH $PYTHONPATH
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
