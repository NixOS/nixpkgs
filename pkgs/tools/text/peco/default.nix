{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "peco";
  version = "0.5.8";

  subPackages = [ "cmd/peco" ];

  src = fetchFromGitHub {
    owner = "peco";
    repo = "peco";
    rev = "v${version}";
    sha256 = "12xbqisk7bcy38fmjxcs069a0600gncbqzscqw6x37lgw6hlw52x";
  };

  vendorSha256 = "1p8pc50ql2vqnn0crx0y558i3m0d6vcdaj3995h3f0908pnk6x7q";

  meta = with lib; {
    description = "Simplistic interactive filtering tool";
    homepage = "https://github.com/peco/peco";
    changelog = "https://github.com/peco/peco/blob/v${version}/Changes";
    license = licenses.mit;
    maintainers = with maintainers; [ pSub ];
  };
}
