{ stdenv, python2Packages, fetchurl, fetchFromGitHub }:
let
  matrix-angular-sdk = python2Packages.buildPythonPackage rec {
    name = "matrix-angular-sdk-${version}";
    version = "0.6.8";

    src = fetchurl {
      url = "mirror://pypi/m/matrix-angular-sdk/matrix-angular-sdk-${version}.tar.gz";
      sha256 = "0gmx4y5kqqphnq3m7xk2vpzb0w2a4palicw7wfdr1q2schl9fhz2";
    };
  };
  matrix-synapse-ldap3 = python2Packages.buildPythonPackage rec {
    pname = "matrix-synapse-ldap3";
    version = "0.1.3";

    src = fetchFromGitHub {
      owner = "matrix-org";
      repo = "matrix-synapse-ldap3";
      rev = "v${version}";
      sha256 = "0ss7ld3bpmqm8wcs64q1kb7vxlpmwk9lsgq0mh21a9izyfc7jb2l";
    };

    propagatedBuildInputs = with python2Packages; [ service-identity ldap3 twisted ];

    checkInputs = with python2Packages; [ ldaptor mock ];
  };
in python2Packages.buildPythonApplication rec {
  name = "matrix-synapse-${version}";
  version = "0.33.3";

  src = fetchFromGitHub {
    owner = "matrix-org";
    repo = "synapse";
    rev = "v${version}";
    sha256 = "0yxxrs8yrrkp3pffdfab8apdmyhdcl90wgmglryy4q8vsksxn7d4";
  };

  patches = [
    ./matrix-synapse.patch
  ];

  propagatedBuildInputs = with python2Packages; [
    blist canonicaljson daemonize dateutil frozendict pillow pyasn1
    pydenticon pymacaroons-pynacl pynacl pyopenssl pysaml2 pytz requests
    signedjson systemd twisted ujson unpaddedbase64 pyyaml prometheus_client
    matrix-angular-sdk bleach netaddr jinja2 psycopg2
    psutil msgpack-python lxml matrix-synapse-ldap3
    phonenumbers jsonschema affinity bcrypt sortedcontainers
  ];

  # Checks fail because of Tox.
  doCheck = false;

  buildInputs = with python2Packages; [
    mock setuptoolsTrial
  ];

  meta = with stdenv.lib; {
    homepage = https://matrix.org;
    description = "Matrix reference homeserver";
    license = licenses.asl20;
    maintainers = with maintainers; [ ralith roblabla ekleog ];
  };
}
