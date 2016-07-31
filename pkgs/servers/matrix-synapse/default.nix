{ lib, pkgs, stdenv, buildPythonApplication, pythonPackages, fetchurl, fetchFromGitHub }:
let
  matrix-angular-sdk = buildPythonApplication rec {
    name = "matrix-angular-sdk-${version}";
    version = "0.6.8";

    src = fetchurl {
      url = "mirror://pypi/m/matrix-angular-sdk/matrix-angular-sdk-${version}.tar.gz";
      sha256 = "0gmx4y5kqqphnq3m7xk2vpzb0w2a4palicw7wfdr1q2schl9fhz2";
    };
  };
in
buildPythonApplication rec {
  name = "matrix-synapse-${version}";
  version = "0.16.1-r1";

  src = fetchFromGitHub {
    owner = "matrix-org";
    repo = "synapse";
    rev = "v${version}";
    sha256 = "0flgaa26j9gga9a9h67b0q3yi0mpnbrjik55220cvvzhy9fnvwa9";
  };

  patches = [ ./matrix-synapse.patch ];

  propagatedBuildInputs = with pythonPackages; [
    blist canonicaljson daemonize dateutil frozendict pillow pybcrypt pyasn1
    pydenticon pymacaroons-pynacl pynacl pyopenssl pysaml2 pytz requests2
    service-identity signedjson systemd twisted ujson unpaddedbase64 pyyaml
    matrix-angular-sdk bleach netaddr jinja2 psycopg2 python.modules.curses
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
