{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "krew";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "kubernetes-sigs";
    repo = "krew";
    rev = "v${version}";
    sha256 = "sha256-+YwBkXrj5sWlMA01GfBhu12st+es5YygkD16jc+blt8=";
  };

  vendorSha256 = "sha256-49kWaU5dYqd86DvHi3mh5jYUQVmFlI8zsWtAFseYriE=";

  subPackages = [ "cmd/krew" ];

  meta = with lib; {
    description = "Package manager for kubectl plugins";
    homepage = "https://github.com/kubernetes-sigs/krew";
    maintainers = with maintainers; [ vdemeester ];
    license = lib.licenses.asl20;
    platforms = platforms.unix;
  };
}
