{ lib, pkgs, stdenv, pythonPackages, fetchurl, fetchFromGitHub }:
let
  matrix-angular-sdk = pythonPackages.buildPythonApplication rec {
    name = "matrix-angular-sdk-${version}";
    version = "0.6.8";

    src = fetchurl {
      url = "mirror://pypi/m/matrix-angular-sdk/matrix-angular-sdk-${version}.tar.gz";
      sha256 = "0gmx4y5kqqphnq3m7xk2vpzb0w2a4palicw7wfdr1q2schl9fhz2";
    };
  };
  matrix-synapse-ldap3 = pythonPackages.buildPythonApplication rec {
    name = "matrix-synapse-ldap3-${version}";
    version = "0.1.2";

    src = fetchFromGitHub {
      owner = "matrix-org";
      repo = "matrix-synapse-ldap3";
      rev = "v${version}";
      sha256 = "16pivz1lhs1c3z84rxxy8khyvn0hqxwxaz552br1y9ri0maa0aq8";
    };

    propagatedBuildInputs = with pythonPackages; [ service-identity ldap3 twisted ];
  };
in pythonPackages.buildPythonApplication rec {
  name = "matrix-synapse-${version}";
  version = "0.22.1";

  src = fetchFromGitHub {
    owner = "matrix-org";
    repo = "synapse";
    rev = "v${version}";
    sha256 = "06kqqsfqmziff7i99yyxqvkqjm7fwi56abc2vy25g9kqzpdvkay7";
  };

  patches = [ ./matrix-synapse.patch ];

  propagatedBuildInputs = with pythonPackages; [
    blist canonicaljson daemonize dateutil frozendict pillow pybcrypt pyasn1
    pydenticon pymacaroons-pynacl pynacl pyopenssl pysaml2 pytz requests
    signedjson systemd twisted ujson unpaddedbase64 pyyaml
    matrix-angular-sdk bleach netaddr jinja2 psycopg2
    psutil msgpack lxml matrix-synapse-ldap3
    phonenumbers jsonschema
  ];

  # Checks fail because of Tox.
  doCheck = false;

  buildInputs = with pythonPackages; [
    mock setuptoolsTrial
  ];

  meta = with stdenv.lib; {
    homepage = https://matrix.org;
    description = "Matrix reference homeserver";
    license = licenses.asl20;
    maintainers = [ maintainers.ralith maintainers.roblabla ];
  };
}
