{ stdenv, fetchFromGitHub, makeWrapper, buildGoModule, wireshark-cli }:

buildGoModule rec {
  pname = "termshark";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "gcla";
    repo = "termshark";
    rev = "v${version}";
    sha256 = "1h9wysvd7i4vzn9qyswrmckmshxmh24ypvca98balkyhsxjwlb6j";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ wireshark-cli ];

  modSha256 = "09mbjbk5wa18z4xis5b2v2v0b04mf4d896yp88vcj8d8hsmbmc6g";

  postFixup = ''
    wrapProgram $out/bin/termshark --prefix PATH : ${stdenv.lib.makeBinPath [ wireshark-cli ]}
  '';

  buildFlagsArray = ''
    -ldflags=
    -X github.com/gcla/termshark.Version=${version}
  '';

  meta = with stdenv.lib; {
    homepage = https://termshark.io/;
    description = "A terminal UI for wireshark-cli, inspired by Wireshark";
    platforms = platforms.linux;
    license = licenses.mit;
    maintainers = [ maintainers.winpat ];
  };
}
