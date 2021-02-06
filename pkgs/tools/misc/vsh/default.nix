{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "vsh";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "fishi0x01";
    repo = "vsh";
    rev = "v${version}";
    sha256 = "1f6szcdakfx3zap1zpkrcs134plv7vnyilzcxs5jbhrrbr6q1807";
  };

  vendorSha256 = "0a2kjql4ibglxkq5dgzr2sxxxm38nf83s4rsk2gd1cf7v0flr02j";

  # vendor dir in vsh repo is incomplete
  deleteVendor = true;

  runVend = true;

  # make sure version gets set at compile time
  buildFlagsArray = [ "-ldflags=-s -w -X main.vshVersion=v${version}" ];

  meta = with lib; {
    description = "HashiCorp Vault interactive shell";
    homepage = "https://github.com/fishi0x01/vsh";
    license = licenses.mit;
    maintainers = with maintainers; [ fishi0x01 ];
  };
}
