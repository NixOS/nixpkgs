{ lib, buildGoModule, fetchFromGitHub, }:

buildGoModule rec {
  pname = "ytcast";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "MarcoLucidi01";
    repo = "ytcast";
    rev = "v${version}";
    sha256 = "0f45ai1s4njhcvbv088yn10i3vdvlm6wlfi0ijq5gak1dg02klma";
  };

  vendorHash = null;
  ldflags = [ "-X main.progVersion=${version}" ];

  meta = with lib; {
    description = "A tool to cast YouTube videos from the command-line";
    homepage = "https://github.com/MarcoLucidi01/ytcast";
    license = licenses.mit;
    maintainers = with maintainers; [ waelwindows ];
    mainProgram = "ytcast";
  };
}
