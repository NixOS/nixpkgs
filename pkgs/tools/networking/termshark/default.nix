{ lib, fetchFromGitHub, makeWrapper, buildGoModule, wireshark-cli }:

buildGoModule rec {
  pname = "termshark";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "gcla";
    repo = "termshark";
    rev = "v${version}";
    sha256 = "sha256-qq7BDGprRkWKRMJiVnqPeTwtHd3tea9dPE8RIPL2YVI=";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ wireshark-cli ];

  vendorHash = "sha256-C9XOiNjo+TZ+erdnypRhhfpbuBhB3yEqNpbtwjEv14g=";

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
