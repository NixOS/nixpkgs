{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "trillian";
  version = "1.5.1";
  vendorSha256 = "sha256-L2aZYwlJq9yVaaKgxa9NoqXTKD/pUq2OMiFftP364Kw=";

  src = fetchFromGitHub {
    owner = "google";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-v5feUTiK6ql0YcRR6RDAj+pS/PZ7vDnSf0ue2rtWb8k=";
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
