{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "vsh";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "fishi0x01";
    repo = "vsh";
    rev = "v${version}";
    sha256 = "0s4i4x8kd9s2igdshgsbs6n3k670h7r6g1mn1pzlj0kpmggnhfik";
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
