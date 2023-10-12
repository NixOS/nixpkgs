{ lib
, stdenv
, fetchFromGitHub
, makeWrapper
, babashka
}:

stdenv.mkDerivation rec {
  pname = "neil";
  version = "0.2.61";

  src = fetchFromGitHub {
    owner = "babashka";
    repo = "neil";
    rev = "v${version}";
    sha256 = "sha256-MoQf7dxdmUlIZZMjuKBJOCu61L8qiAlmVssf6pUhqA8=";
  };

  nativeBuildInputs = [ makeWrapper ];

  dontBuild = true;

  installPhase = ''
    install -D neil $out/bin/neil
    wrapProgram $out/bin/neil \
      --prefix PATH : "${lib.makeBinPath [ babashka ]}"
  '';

  meta = with lib; {
    homepage = "https://github.com/babashka/neil";
    description = "A CLI to add common aliases and features to deps.edn-based projects";
    license = licenses.mit;
    platforms = babashka.meta.platforms;
    maintainers = with maintainers; [ jlesquembre ];
  };
}
