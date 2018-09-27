{ stdenv, fetchFromGitHub, makeWrapper, bash, gawk, curl, netcat, ncurses }:

stdenv.mkDerivation rec {
  name = "twa-${version}";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "trailofbits";
    repo = "twa";
    rev = version;
    sha256 = "16x9nzsrf10waqmjm423vx44820c6mls7gxc8azrdqnz18vdy1h4";
  };

  dontBuild = true;

  buildInputs = [ makeWrapper bash gawk curl netcat ];

  installPhase = ''
    install -Dm 0755 twa "$out/bin/twa"
    install -Dm 0755 tscore "$out/bin/tscore"
    install -Dm 0644 twa.1 "$out/share/man/man1/twa.1"
    install -Dm 0644 README.md "$out/share/doc/twa/README.md"

    wrapProgram "$out/bin/twa" \
      --prefix PATH : ${stdenv.lib.makeBinPath [ curl netcat ncurses ]}
  '';

  meta = {
    description = "A tiny web auditor with strong opinions";
    homepage = https://github.com/trailofbits/twa;
    license = stdenv.lib.licenses.mit;
    maintainers = with stdenv.lib.maintainers; [ avaq ];
  };
}
