{ lib, fetchFromGitHub, makeWrapper, buildGoModule, wireshark-cli }:

buildGoModule rec {
  pname = "termshark";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "gcla";
    repo = "termshark";
    rev = "v${version}";
    sha256 = "sha256-ekIxKBnqGTIXncvSTItBL43WN5mdX5dxROWHXUtH3o8=";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ wireshark-cli ];

  vendorSha256 = "sha256-16JPVgo3heJMjOHNOP13kyhRveQjF9h9kRznhSZM+ik=";

  doCheck = false;

  postFixup = ''
    wrapProgram $out/bin/termshark --prefix PATH : ${lib.makeBinPath [ wireshark-cli ]}
  '';

  ldflags = [
    "-X github.com/gcla/termshark.Version=${version}"
  ];

  meta = with lib; {
    homepage = "https://termshark.io/";
    description = "A terminal UI for wireshark-cli, inspired by Wireshark";
    license = licenses.mit;
    maintainers = with maintainers; [ winpat ];
  };
}
