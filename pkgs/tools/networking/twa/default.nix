{ stdenv
, bash
, curl
, fetchFromGitHub
, gawk
, host
, jq
, lib
, makeWrapper
, ncurses
, netcat
}:

stdenv.mkDerivation rec {
  pname = "twa";
  version = "1.9.1";

  src = fetchFromGitHub {
    owner = "trailofbits";
    repo = "twa";
    rev = version;
    sha256 = "1ab3bcyhfach9y15w8ffvqqan2qk8h62n6z8nqbgygi7n1mf6jzx";
  };

  dontBuild = true;

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [ bash
                  curl
                  gawk
                  host.dnsutils
                  jq
                  netcat ];

  installPhase = ''
    install -Dm 0755 twa "$out/bin/twa"
    install -Dm 0755 tscore "$out/bin/tscore"
    install -Dm 0644 twa.1 "$out/share/man/man1/twa.1"
    install -Dm 0644 README.md "$out/share/doc/twa/README.md"

    wrapProgram "$out/bin/twa" \
      --prefix PATH : ${stdenv.lib.makeBinPath [ curl
                                                 host.dnsutils
                                                 jq
                                                 ncurses
                                                 netcat ]}
  '';

  meta = with lib; {
    description = "A tiny web auditor with strong opinions";
    homepage = https://github.com/trailofbits/twa;
    license = licenses.mit;
    maintainers = with maintainers; [ avaq ];
    platforms = platforms.unix;
  };
}
