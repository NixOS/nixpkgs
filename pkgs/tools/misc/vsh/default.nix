{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "vsh";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "fishi0x01";
    repo = "vsh";
    rev = "v${version}";
    sha256 = "16q0pkmdzhq0bqy4lnnlxrc29gszca6vwajj2bg6sylcvi94x80d";
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
