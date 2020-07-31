{ stdenv, fetchFromGitHub, makeWrapper, buildGoModule, wireshark-cli }:

buildGoModule rec {
  pname = "termshark";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "gcla";
    repo = "termshark";
    rev = "v${version}";
    sha256 = "14h548apg3zvjvq6yy22hpw2ziy5vmwyr04vv59ls1mjg4qf2v8b";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ wireshark-cli ];

  vendorSha256 = "14apff3vcbndr30765lzi4qswakavb4396bjixxvpxv6i5c04dq7";

  postFixup = ''
    wrapProgram $out/bin/termshark --prefix PATH : ${stdenv.lib.makeBinPath [ wireshark-cli ]}
  '';

  buildFlagsArray = ''
    -ldflags=
    -X github.com/gcla/termshark.Version=${version}
  '';

  meta = with stdenv.lib; {
    homepage = "https://termshark.io/";
    description = "A terminal UI for wireshark-cli, inspired by Wireshark";
    license = licenses.mit;
    maintainers = with maintainers; [ winpat elseym ];
  };
}
