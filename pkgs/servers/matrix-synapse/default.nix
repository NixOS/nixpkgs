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
  version = "1.41.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1vaym6mxnwg2xdqjcigi2sb0kkdi0ly5d5ghakfsysxcfn08d1z8";
  };

  patches = [
    ./0001-setup-add-homeserver-as-console-script.patch
  ];

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
    prometheus-client
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
    ++ lib.optionals enableRedis [ hiredis txredisapi ];

  checkInputs = [ mock parameterized openssl ];

  doCheck = !stdenv.isDarwin;

  checkPhase = ''
    PYTHONPATH=".:$PYTHONPATH" ${python3.interpreter} -m twisted.trial tests
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
