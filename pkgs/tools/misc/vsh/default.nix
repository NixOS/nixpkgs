{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "vsh";
  version = "0.7.2";

  src = fetchFromGitHub {
    owner = "fishi0x01";
    repo = "vsh";
    rev = "v${version}";
    sha256 = "0k9bbfzqhijzimng8plk2xx9h37h7d2wj8g3plvvs3wrf7pmwxs7";
  };

  # vendor dir is already part of repository
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
