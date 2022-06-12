{ lib
, buildGoModule
, fetchFromGitHub
, nixosTests
}:

buildGoModule rec {
  pname = "pebble";
  version = "2.3.1";

  src = fetchFromGitHub {
    owner = "letsencrypt";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-S9+iRaTSRt4F6yMKK0OJO6Zto9p0dZ3q/mULaipudVo=";
  };

  vendorSha256 = null;

  passthru.tests = {
    smoke-test = nixosTests.acme;
  };

  meta = {
    homepage = "https://github.com/letsencrypt/pebble";
    description = "A miniature version of Boulder, Pebble is a small RFC 8555 ACME test server not suited for a production CA";
    license = [ lib.licenses.mpl20 ];
    maintainers = lib.teams.acme.members;
  };
}
