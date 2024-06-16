{ lib, buildGoModule, fetchFromGitea }:

buildGoModule rec {
  pname = "lenpaste";
  version = "1.3";

  src = fetchFromGitea {
    domain = "git.lcomrade.su";
    owner = "root";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-d+FjfEbInlxUllWIoVLwQRdRWjxBLTpNHYn+oYU3fBc=";
  };

  vendorHash = "sha256-PL0dysBn1+1BpZWFW/EUFJtqkabt+XN00YkAz8Yf2LQ=";

  ldflags = [
    "-w"
    "-s"
    "-X main.Version=${version}"
  ];

  subPackages = [ "cmd" ];

  postInstall = ''
    mv $out/bin/cmd $out/bin/lenpaste
  '';

  meta = with lib; {
    description = "A web service that allows you to share notes anonymously, an alternative to pastebin.com";
    homepage = "https://git.lcomrade.su/root/lenpaste";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ vector1dev ];
    mainProgram = "lenpaste";
  };
}
