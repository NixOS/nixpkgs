{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "trillian";
  version = "1.5.0";
  vendorSha256 = "sha256-235uQK4E/GLl5XLBd6lkTIgWIjT9MZZGnyfZbOoTFo0=";

  src = fetchFromGitHub {
    owner = "google";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-XZHVGuIN+5mFbaxOprhdHlpgz2NE2NsJxGWJciDMUqI=";
  };

  subPackages = [
    "cmd/trillian_log_server"
    "cmd/trillian_log_signer"
    "cmd/createtree"
    "cmd/deletetree"
    "cmd/updatetree"
  ];

  meta = with lib; {
    homepage = "https://github.com/google/trillian";
    description = "A transparent, highly scalable and cryptographically verifiable data store.";
    license = [ licenses.asl20 ];
    maintainers = [ maintainers.adisbladis ];
  };
}
