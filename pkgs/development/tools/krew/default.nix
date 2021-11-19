{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "krew";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "kubernetes-sigs";
    repo = "krew";
    rev = "v${version}";
    sha256 = "sha256-P4b8HMkqxzYKz9OgI4pNCjR9Wakh+kIIAnUAkayzGEo=";
  };

  vendorSha256 = "sha256-FQQCHq9f0yY8vSsvWIR7WKq+0c+dgGEnoQmXtoN6Ep0=";

  subPackages = [ "cmd/krew" ];

  meta = with lib; {
    description = "Package manager for kubectl plugins";
    homepage = "https://github.com/kubernetes-sigs/krew";
    maintainers = with maintainers; [ vdemeester ];
    license = lib.licenses.asl20;
    platforms = platforms.unix;
  };
}
