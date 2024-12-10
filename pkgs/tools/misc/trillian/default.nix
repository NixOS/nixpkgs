{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "trillian";
  version = "1.6.0";
  vendorHash = "sha256-tLhq6ILiKzFM1lIK0DbiIKsn1NWEI168BMaf/MOAtEo=";

  src = fetchFromGitHub {
    owner = "google";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-YHwT+ddVRyHkmXkw2vROL4PS948pOMj9UwOtHorbTAQ=";
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
    description = "A transparent, highly scalable and cryptographically verifiable data store";
    license = [ licenses.asl20 ];
    maintainers = [ maintainers.adisbladis ];
  };
}
