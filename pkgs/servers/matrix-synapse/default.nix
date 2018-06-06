{ lib, pkgs, stdenv, pythonPackages, fetchurl, fetchFromGitHub, fetchpatch }:
let
  matrix-angular-sdk = pythonPackages.buildPythonPackage rec {
    name = "matrix-angular-sdk-${version}";
    version = "0.6.8";

    src = fetchurl {
      url = "mirror://pypi/m/matrix-angular-sdk/matrix-angular-sdk-${version}.tar.gz";
      sha256 = "0gmx4y5kqqphnq3m7xk2vpzb0w2a4palicw7wfdr1q2schl9fhz2";
    };
  };
  matrix-synapse-ldap3 = pythonPackages.buildPythonPackage rec {
    pname = "matrix-synapse-ldap3";
    version = "0.1.3";

    src = fetchFromGitHub {
      owner = "matrix-org";
      repo = "matrix-synapse-ldap3";
      rev = "v${version}";
      sha256 = "0ss7ld3bpmqm8wcs64q1kb7vxlpmwk9lsgq0mh21a9izyfc7jb2l";
    };

    propagatedBuildInputs = with pythonPackages; [ service-identity ldap3 twisted ];

    checkInputs = with pythonPackages; [ ldaptor mock ];
  };
in pythonPackages.buildPythonApplication rec {
  name = "matrix-synapse-${version}";
  version = "0.30.0";

  src = fetchFromGitHub {
    owner = "matrix-org";
    repo = "synapse";
    rev = "v${version}";
    sha256 = "10ggv7669ngxs8py82k8z24874ga0ldcxvpp7xhjpbr1s0gw8zv8";
  };

  patches = [
    ./matrix-synapse.patch
  ];

  propagatedBuildInputs = with pythonPackages; [
    blist canonicaljson daemonize dateutil frozendict pillow pyasn1
    pydenticon pymacaroons-pynacl pynacl pyopenssl pysaml2 pytz requests
    signedjson systemd twisted ujson unpaddedbase64 pyyaml
    matrix-angular-sdk bleach netaddr jinja2 psycopg2
    psutil msgpack-python lxml matrix-synapse-ldap3
    phonenumbers jsonschema affinity bcrypt
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
