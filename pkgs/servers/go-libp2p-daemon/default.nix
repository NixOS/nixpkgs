{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule {
  pname = "go-libp2p-daemon";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "libp2p";
    repo = "go-libp2p-daemon";
    rev = "bfa207ed34c27947f0828a4ae8d10bda62aa49a9";
    sha256 = "1f3gjkmpqngajjpijpjdmkmsjfm9bdgakb5r28fnc6w9dmfyj51x";
  };

  vendorSha256 = "0g25r7wd1hvnwxxq18mpx1r1wig6dnlnvzkpvgw79q6nymxlppmv";

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/libp2p/go-libp2p-daemon";
    license = licenses.mit;
    maintainers = with maintainers; [ fare ];
  };
}
