{ lib, stdenv, python2Packages, fetchurl, fetchFromGitHub
, enableSystemd ? true
}:
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
  version = "0.33.8";

  src = fetchFromGitHub {
    owner = "matrix-org";
    repo = "synapse";
    rev = "v${version}";
    sha256 = "122ba09xkc1x35qaajcynkjikg342259rgy81m8abz0l8mcg4mkm";
  };

  patches = [
    ./matrix-synapse.patch
  ];

  propagatedBuildInputs = with python2Packages; [
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

  doCheck = true;
  checkPhase = "python -m twisted.trial test";

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
