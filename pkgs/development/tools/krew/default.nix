{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "krew";
  version = "0.4.3";

  src = fetchFromGitHub {
    owner = "kubernetes-sigs";
    repo = "krew";
    rev = "v${version}";
    sha256 = "sha256-aW9yASskwDt+5Lvsdju9ZR/HeZ4x8heWljdhqK0ZTx8=";
  };

  vendorSha256 = "sha256-VXGjKzkOpaxyJClwXbxg15xmGdFi6arH8f4nN5/1SA4=";

  subPackages = [ "cmd/krew" ];

  meta = with lib; {
    description = "Package manager for kubectl plugins";
    homepage = "https://github.com/kubernetes-sigs/krew";
    maintainers = with maintainers; [ vdemeester ];
    license = lib.licenses.asl20;
  };
}
