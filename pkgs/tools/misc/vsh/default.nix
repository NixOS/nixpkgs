{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "vsh";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "fishi0x01";
    repo = "vsh";
    rev = "v${version}";
    sha256 = "059zzsg94287sxlk5clz6in7jscqaq530c84xqgy537f6cq3vr2p";
  };

  # vendor directory is part of repository
  vendorSha256 = null;

  # make sure version gets set at compile time
  ldflags = [ "-s" "-w" "-X main.vshVersion=v${version}" ];

  meta = with lib; {
    description = "HashiCorp Vault interactive shell";
    homepage = "https://github.com/fishi0x01/vsh";
    license = licenses.mit;
    maintainers = with maintainers; [ fishi0x01 ];
  };
}
