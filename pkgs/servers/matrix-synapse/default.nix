{ pkgs, stdenv, buildPythonApplication, pythonPackages, fetchurl, fetchFromGitHub }:
let
  matrix-angular-sdk = buildPythonApplication rec {
    name = "matrix-angular-sdk-${version}";
    version = "0.6.6";

    src = fetchurl {
      url = "https://pypi.python.org/packages/source/m/matrix-angular-sdk/matrix-angular-sdk-${version}.tar.gz";
      sha256 = "1vknhmibb8gh8lng50va2cdvng5xm7vqv9dl680m3gj38pg0bv8a";
    };
  };
in
buildPythonApplication rec {
  name = "matrix-synapse-${version}";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "matrix-org";
    repo = "synapse";
    rev = "f35f8d06ea58e2d0cdccd82924c7a44fd93f4c38";
    sha256 = "0b0k1am9lh0qglagc06m91qs26ybv37k7wpbg5333x8jaf5d1si4";
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
