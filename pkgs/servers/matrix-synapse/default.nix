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
in pythonPackages.buildPythonApplication rec {
  name = "matrix-synapse-${version}";
  version = "0.18.4";

  src = fetchFromGitHub {
    owner = "matrix-org";
    repo = "synapse";
    rev = "v${version}";
    sha256 = "0hcag9a4wd6a9q0ln5l949xr1bhmk1zrnf9vf3qi3lzxgi0rbm98";
  };

  patches = [ ./matrix-synapse.patch ];

  propagatedBuildInputs = with pythonPackages; [
    blist canonicaljson daemonize dateutil frozendict pillow pybcrypt pyasn1
    pydenticon pymacaroons-pynacl pynacl pyopenssl pysaml2 pytz requests2
    service-identity signedjson systemd twisted ujson unpaddedbase64 pyyaml
    matrix-angular-sdk bleach netaddr jinja2 psycopg2
    ldap3 psutil msgpack lxml
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
