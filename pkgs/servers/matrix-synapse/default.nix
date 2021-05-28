{ lib, stdenv, python3, openssl
, enableSystemd ? stdenv.isLinux, nixosTests
}:

with python3.pkgs;

let
  plugins = python3.pkgs.callPackage ./plugins { };
in
buildPythonApplication rec {
  pname = "matrix-synapse";
  version = "1.21.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0iip311xbzc984gzpmri5fabpb3b2ck1ywv5378pk90m02yybgi5";
  };

  patches = [
    # adds an entry point for the service
    ./homeserver-script.patch
  ];

  propagatedBuildInputs = [
    setuptools
    bcrypt
    bleach
    canonicaljson
    daemonize
    frozendict
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
    pymacaroons
    pynacl
    pyopenssl
    pysaml2
    pyyaml
    requests
    signedjson
    sortedcontainers
    treq
    twisted
    unpaddedbase64
    typing-extensions
    authlib
    pyjwt
  ] ++ lib.optional enableSystemd systemd;

  checkInputs = [ mock parameterized openssl ];

  doCheck = !stdenv.isDarwin;

  checkPhase = ''
    PYTHONPATH=".:$PYTHONPATH" ${python3.interpreter} -m twisted.trial tests
  '';

  passthru.tests = { inherit (nixosTests) matrix-synapse; };
  passthru.plugins = plugins;
  passthru.python = python3;

  meta = with stdenv.lib; {
    homepage = "https://matrix.org";
    description = "Matrix reference homeserver";
    license = licenses.asl20;
    maintainers = teams.matrix.members;
  };
}
