{ stdenv, fetchFromGitHub, makeWrapper, buildGoModule, wireshark-cli, Security }:

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
  buildInputs = [ wireshark-cli ]
    ++ stdenv.lib.optionals stdenv.isDarwin [ Security ];

  modSha256 = "0lp4gky76di7as78421p3lsirfr7mic3z204ildvj6gf6d15svpr";

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
    license = licenses.mit;
    maintainers = with maintainers; [ winpat elseym ];
  };
}
