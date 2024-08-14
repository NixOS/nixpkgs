{ lib
, stdenv
, buildGoModule
, fetchFromGitHub
, nixosTests
}:

buildGoModule rec {
  pname = "pebble";
  version = "2.6.0";

  src = fetchFromGitHub {
    owner = "letsencrypt";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-YPU/bl7h6rOWg+5ut0Thn2UupeKpJ7u4KXc2svIeZEM=";
  };

  vendorHash = null;

  passthru.tests = {
    smoke-test = nixosTests.acme;
  };

  meta = {
    # ca/ca.go:374:67: 9223372038 (untyped int constant) overflows uint
    broken = stdenv.hostPlatform.is32bit;
    homepage = "https://github.com/letsencrypt/pebble";
    description = "Miniature version of Boulder, Pebble is a small RFC 8555 ACME test server not suited for a production CA";
    license = [ lib.licenses.mpl20 ];
    maintainers = lib.teams.acme.members;
  };
}
