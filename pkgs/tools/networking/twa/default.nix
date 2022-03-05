{ lib
, stdenv
, fetchFromGitHub
, makeWrapper
, bash
, curl
, dnsutils
, gawk
, jq
, ncurses
, netcat
}:

stdenv.mkDerivation rec {
  pname = "twa";
  version = "1.10.0";

  src = fetchFromGitHub {
    owner = "trailofbits";
    repo = "twa";
    rev = "v${version}";
    hash = "sha256-8c1o03iwStmhjKHmEXIZGyaSOAJRlOuhu0ERjCO5SHg=";
  };

  dontBuild = true;

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [ bash
                  curl
                  dnsutils
                  gawk
                  jq
                  netcat ];

  installPhase = ''
    runHook preInstall

    install -Dm 0755 twa "$out/bin/twa"
    install -Dm 0755 tscore "$out/bin/tscore"
    install -Dm 0644 twa.1 "$out/share/man/man1/twa.1"
    install -Dm 0644 README.md "$out/share/doc/twa/README.md"

    wrapProgram "$out/bin/twa" \
      --prefix PATH : ${lib.makeBinPath [ curl
                                          dnsutils
                                          gawk
                                          jq
                                          ncurses
                                          netcat ]}

    runHook postInstall
  '';

  meta = with lib; {
    description = "A tiny web auditor with strong opinions";
    homepage = "https://github.com/trailofbits/twa";
    license = licenses.mit;
    maintainers = with maintainers; [ avaq ];
    platforms = platforms.unix;
  };
}
