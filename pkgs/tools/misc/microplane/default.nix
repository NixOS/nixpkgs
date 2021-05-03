{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "microplane";
  version = "0.0.28";

  src = fetchFromGitHub {
    owner = "Clever";
    repo = "microplane";
    rev = "v${version}";
    sha256 = "00ayci0a4lv67sg2bb4fw5wpdlps4pjqiiam595dar82lsjwj63j";
  };

  vendorSha256 = "0hn2gsm9bgmrm620fn2cx28l2gj1yfgvjix9ds50m7kwkx6q0dga";

  buildFlagsArray = ''
    -ldflags="-s -w -X main.version=v${version}"
  '';

  postInstall = ''
    ln -s $out/bin/microplane $out/bin/mp
  '';

  meta = with lib; {
    description = "A CLI tool to make git changes across many repos";
    homepage = "https://github.com/Clever/microplane";
    license = licenses.asl20;
    maintainers = with maintainers; [ dbirks ];
  };
}
