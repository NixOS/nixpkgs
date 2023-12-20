{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kail";
  version = "0.17.1";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  src = fetchFromGitHub {
    owner = "boz";
    repo = "kail";
    rev = "v${version}";
    sha256 = "sha256-AmbgrSG8Mc4cHEDn9qtaAQ/RQjSDS5JjKhqZAcHYLV4=";
  };

  vendorHash = "sha256-80ZZZWTRmCClHkfsV/0WStuZ/xcxyycA5Fg4W2BqtF8=";

  meta = with lib; {
    description = "Kubernetes log viewer";
    homepage = "https://github.com/boz/kail";
    license = licenses.mit;
    maintainers = with maintainers; [ offline vdemeester ];
  };
}
