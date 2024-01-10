{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "trillian";
  version = "1.5.3";
  vendorHash = "sha256-DsdkTYRQQjTCArD3bo1al8enFzjfT7DVfmjK5KUqPDI=";

  src = fetchFromGitHub {
    owner = "google";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-fXqoe59JU5efAo5ByJ4027oqHakNCTvAtAq48MJZ9ZE=";
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
