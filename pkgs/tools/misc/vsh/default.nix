{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "vsh";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "fishi0x01";
    repo = "vsh";
    rev = "v${version}";
    sha256 = "0dhn2aqd52fgasy4j3ar67fzwzcxfi1vl09kni8jwcna8rjgg3fj";
  };

  # vendor directory is part of repository
  vendorSha256 = null;

  # make sure version gets set at compile time
  buildFlagsArray = [ "-ldflags=-s -w -X main.vshVersion=v${version}" ];

  meta = with lib; {
    description = "HashiCorp Vault interactive shell";
    homepage = "https://github.com/fishi0x01/vsh";
    license = licenses.mit;
    maintainers = with maintainers; [ fishi0x01 ];
  };
}
