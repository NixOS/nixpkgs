{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "vsh";
  version = "0.12.1";

  src = fetchFromGitHub {
    owner = "fishi0x01";
    repo = "vsh";
    rev = "v${version}";
    sha256 = "0skd16j969mb2kgq503wskaw8clyhkw135ny2nsqv5j2zjpr71ap";
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
