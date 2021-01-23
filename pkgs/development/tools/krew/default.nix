{ lib, stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "krew";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "kubernetes-sigs";
    repo = "krew";
    rev = "v${version}";
    sha256 = "1fcbpipnbms096c36b2z06ysfwyjj22lm1zd1r5xlv5gp24qimlv";
  };

  vendorSha256 = "1bmsjv5snrabd9h9szkpcl15rwxm54jgm361ghhy234d2s45c3gn";

  subPackages = [ "cmd/krew" ];

  meta = with lib; {
    description = "Package manager for kubectl plugins";
    homepage = "https://github.com/kubernetes-sigs/krew";
    maintainers = with maintainers; [ vdemeester ];
    license = lib.licenses.asl20;
    platforms = platforms.unix;
  };
}
