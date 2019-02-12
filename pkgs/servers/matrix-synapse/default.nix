{ lib, stdenv, python3
, enableSystemd ? true
}:

with python3.pkgs;

let
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
  version = "0.99.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1xsp60172zvgyjgpjmzz90rj1din8d65ffg73nzid4nd875p45kh";
  };

  propagatedBuildInputs = [
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
  ] ++ lib.optional enableSystemd systemd;

  checkInputs = [ mock ];

  checkPhase = ''
    PYTHONPATH=".:$PYTHONPATH" trial tests
  '';

  meta = with stdenv.lib; {
    homepage = https://matrix.org;
    description = "Matrix reference homeserver";
    license = licenses.asl20;
    maintainers = with maintainers; [ ralith roblabla ekleog ];
  };
}
