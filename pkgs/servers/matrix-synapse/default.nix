{ lib, stdenv, python2
, enableSystemd ? true
}:

with python2.pkgs;

let
  matrix-angular-sdk = buildPythonPackage rec {
    pname = "matrix-angular-sdk";
    version = "0.6.8";

    src = fetchPypi {
      inherit pname version;
      sha256 = "0gmx4y5kqqphnq3m7xk2vpzb0w2a4palicw7wfdr1q2schl9fhz2";
    };

    # no checks from Pypi but as this is abandonware, there will be no
    # new version anyway
    doCheck = false;
  };

  matrix-synapse-ldap3 = buildPythonPackage rec {
    pname = "matrix-synapse-ldap3";
    version = "0.1.3";

    src = fetchPypi {
      inherit pname version;
      sha256 = "0a0d1y9yi0abdkv6chbmxr3vk36gynnqzrjhbg26q4zg06lh9kgn";
    };

    propagatedBuildInputs = [ service-identity ldap3 twisted ];

    # ldaptor is not ready for py3 yet
    doCheck = !isPy3k;
    checkInputs = [ ldaptor mock ];
  };

in buildPythonApplication rec {
  pname = "matrix-synapse";
  version = "0.33.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1wdpywqi1xd6dy3hxnnjnh2amlmhljf8s0bff9v55jyh42bj1vpn";
  };

  patches = [
    ./matrix-synapse.patch
  ];

  propagatedBuildInputs = [
    bcrypt
    bleach
    canonicaljson
    daemonize
    dateutil
    frozendict
    jinja2
    jsonschema
    lxml
    matrix-angular-sdk
    matrix-synapse-ldap3
    msgpack-python
    netaddr
    phonenumbers
    pillow
    prometheus_client
    psutil
    psycopg2
    pyasn1
    pydenticon
    pymacaroons-pynacl
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
  ] ++ lib.optional enableSystemd systemd;

  # tests fail under py3 for now, but version 0.34.0 will use py3 by default
  # https://github.com/matrix-org/synapse/issues/4036
  doCheck = true;
  checkPhase = "python -m twisted.trial test";

  checkInputs = [ mock setuptoolsTrial ];

  meta = with stdenv.lib; {
    homepage = https://matrix.org;
    description = "Matrix reference homeserver";
    license = licenses.asl20;
    maintainers = with maintainers; [ ralith roblabla ekleog ];
  };
}
