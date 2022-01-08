{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "trillian";
  version = "1.4.0";
  vendorSha256 = "sha256-n5PD3CGgNGrqSYLJS+3joGFNue2fF/tdimC6CtO15yU=";

  src = fetchFromGitHub {
    owner = "google";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-c7Sii6GMWZOeD46OwdkXU/wt9zY+EyPSnahYPJQKJcA=";
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
