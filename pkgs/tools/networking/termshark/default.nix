{ lib, fetchFromGitHub, makeWrapper, buildGoModule, wireshark-cli }:

buildGoModule rec {
  pname = "termshark";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "gcla";
    repo = "termshark";
    rev = "v${version}";
    sha256 = "sha256-vS6j8Mcri3SI/6HqtFX/EzVl8S0lx8fWU+0ddjzJz8g=";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ wireshark-cli ];

  vendorSha256 = "sha256-md9HHiYOsBimCBjD1FyjTqnskCZksQiEggWd5UW0RPM=";

  doCheck = false;

  postFixup = ''
    wrapProgram $out/bin/termshark --prefix PATH : ${lib.makeBinPath [ wireshark-cli ]}
  '';

  buildFlagsArray = ''
    -ldflags=
    -X github.com/gcla/termshark.Version=${version}
  '';

  meta = with lib; {
    homepage = "https://termshark.io/";
    description = "A terminal UI for wireshark-cli, inspired by Wireshark";
    license = licenses.mit;
    maintainers = with maintainers; [ winpat elseym ];
  };
}
