{ pkgs, stdenv, buildPythonApplication, pythonPackages, fetchurl, fetchFromGitHub }:
let
  matrix-angular-sdk = buildPythonApplication rec {
    name = "matrix-angular-sdk-${version}";
    version = "0.6.8";

    src = fetchurl {
      url = "https://pypi.python.org/packages/source/m/matrix-angular-sdk/matrix-angular-sdk-${version}.tar.gz";
      sha256 = "0gmx4y5kqqphnq3m7xk2vpzb0w2a4palicw7wfdr1q2schl9fhz2";
    };
  };
in
buildPythonApplication rec {
  name = "matrix-synapse-${version}";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "matrix-org";
    repo = "synapse";
    rev = "5fbdf2bcec40bf2f24fc0698440ee384595ff027";
    sha256 = "1f9flb68l0bb5fkggxz1pghv72snsx6yia3s58f85z13f9vh84cb";
  };

  patches = [ ./matrix-synapse.patch ];

  propagatedBuildInputs = with pythonPackages; [
    blist canonicaljson daemonize dateutil frozendict pillow pybcrypt pyasn1
    pydenticon pymacaroons-pynacl pynacl pyopenssl pysaml2 pytz requests2
    service-identity signedjson systemd twisted ujson unpaddedbase64 pyyaml
    matrix-angular-sdk
  ];

  # Checks fail because of Tox.
  doCheck = false;

  buildInputs = with pythonPackages; [
    mock setuptoolsTrial
  ];

  meta = {
    homepage = https://matrix.org;
    description = "Matrix reference homeserver";
    license = stdenv.lib.licenses.asl20;
  };
}
