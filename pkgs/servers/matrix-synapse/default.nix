{ lib, stdenv, python3, openssl
, enableSystemd ? stdenv.isLinux, nixosTests
, enableRedis ? false
}:

with python3.pkgs;

let
  matrix-synapse-ldap3 = buildPythonPackage rec {
    pname = "matrix-synapse-ldap3";
    version = "0.1.4";

    src = fetchPypi {
      inherit pname version;
      sha256 = "01bms89sl16nyh9f141idsz4mnhxvjrc3gj721wxh1fhikps0djx";
    };

    propagatedBuildInputs = [ service-identity ldap3 twisted ];

    # ldaptor is not ready for py3 yet
    doCheck = !isPy3k;
    checkInputs = [ ldaptor mock ];
  };

in buildPythonApplication rec {
  pname = "matrix-synapse";
  version = "1.22.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1pbxdqpfa7wzdz61p6x58x7841vng1g65qayxgcw73bn1shl50jb";
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
    matrix-synapse-ldap3
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
  ] ++ lib.optional enableSystemd systemd
    ++ lib.optional enableRedis hiredis;

  checkInputs = [ mock parameterized openssl ];

  doCheck = !stdenv.isDarwin;

  passthru.tests = { inherit (nixosTests) matrix-synapse; };

  checkPhase = ''
    ${lib.optionalString (!enableRedis) "rm -r tests/replication # these tests need the optional dependency 'hiredis'"}
    PYTHONPATH=".:$PYTHONPATH" ${python3.interpreter} -m twisted.trial tests
  '';

  meta = with stdenv.lib; {
    homepage = https://matrix.org;
    description = "Matrix reference homeserver";
    license = licenses.asl20;
    maintainers = with maintainers; [ ralith roblabla ekleog pacien ma27 ];
  };
}
