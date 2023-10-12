{ lib
, stdenv
, buildGoModule
, fetchFromGitHub
, nixosTests
}:

buildGoModule rec {
  pname = "pebble";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "letsencrypt";
    repo = pname;
    rev = "v${version}";
    sha256 = "0sh67bzq3hlagk73w2kp45viq15g2rcxm760jk9fqshamq784m6m";
  };

  vendorHash = null;

  passthru.tests = {
    smoke-test = nixosTests.acme;
  };

  meta = {
    # ca/ca.go:374:67: 9223372038 (untyped int constant) overflows uint
    broken = stdenv.hostPlatform.is32bit;
    homepage = "https://github.com/letsencrypt/pebble";
    description = "A miniature version of Boulder, Pebble is a small RFC 8555 ACME test server not suited for a production CA";
    license = [ lib.licenses.mpl20 ];
    maintainers = lib.teams.acme.members;
  };
}
