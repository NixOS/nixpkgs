{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "peco";
  version = "0.5.10";

  subPackages = [ "cmd/peco" ];

  src = fetchFromGitHub {
    owner = "peco";
    repo = "peco";
    rev = "v${version}";
    sha256 = "sha256-Iu2MclUbUYX1FuMnE65Qdk0S+5+K3HW86WIdQrNUyY8=";
  };

  vendorSha256 = "sha256-+HQz7UUgATdgSWlI1dg2DdQRUSke9MyAtXgLikFhF90=";

  meta = with lib; {
    description = "Simplistic interactive filtering tool";
    homepage = "https://github.com/peco/peco";
    changelog = "https://github.com/peco/peco/blob/v${version}/Changes";
    license = licenses.mit;
    maintainers = with maintainers; [ pSub ];
  };
}
