{ lib, stdenv, python3, openssl
, enableSystemd ? stdenv.isLinux, nixosTests
}:

with python3.pkgs;

let
  plugins = python3.pkgs.callPackage ./plugins { };
in
buildPythonApplication rec {
  pname = "matrix-synapse";
  version = "1.18.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0bqacma2ip0l053rfvxznbixs2rmb2dawqi2jq2zbqk5jqxhpaxi";
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
    (prometheus_client.overrideAttrs (x: {
      src = fetchPypi {
        pname = "prometheus_client";
        version = "0.3.1";
        sha256 = "093yhvz7lxl7irnmsfdnf2030lkj4gsfkg6pcmy4yr1ijk029g0p";
      };
    }))
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
