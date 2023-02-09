{ lib
, stdenv
, fetchFromGitHub
, makeWrapper
, babashka
, jdk
}:

stdenv.mkDerivation rec {
  pname = "neil";
  version = "0.1.47";

  src = fetchFromGitHub {
    owner = "babashka";
    repo = "neil";
    rev = "v${version}";
    sha256 = "sha256-fsFIBT1voh6QcGRoGYx10JoKqZuV3xcA+eOo03DYz1s=";
  };

  nativeBuildInputs = [ makeWrapper ];

  dontBuild = true;

  installPhase = ''
    install -D neil $out/bin/neil
    wrapProgram $out/bin/neil \
      --prefix PATH : "${lib.makeBinPath [ babashka jdk ]}"
  '';

  meta = with lib; {
    homepage = "https://github.com/babashka/neil";
    description = "A CLI to add common aliases and features to deps.edn-based projects";
    license = licenses.mit;
    platforms = babashka.meta.platforms;
    maintainers = with maintainers; [ jlesquembre ];
  };
}
