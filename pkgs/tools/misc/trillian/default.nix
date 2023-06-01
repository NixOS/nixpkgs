{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "trillian";
  version = "1.5.2";
  vendorHash = "sha256-DlqezeMZsOaCoqvGMiU+fHMq+p3tZ+XBulB/G3BJESM=";

  src = fetchFromGitHub {
    owner = "google";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-m+22UK37IBCo48AgzINxKvudhEwvStz6fLWjE49saIg=";
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
