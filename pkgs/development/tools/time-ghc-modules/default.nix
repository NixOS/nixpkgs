{ lib
, stdenv
, fetchFromGitHub
, makeWrapper
, sqlite
, python3
, coreutils
, findutils
, gnused
}:

stdenv.mkDerivation rec {
  pname = "time-ghc-modules";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "codedownio";
    repo = "time-ghc-modules";
    rev = version;
    sha256 = "0s6540gllhjn7366inhwa70rdnngnhbi07jn1h6x8a0pi71wdfm9";
  };

  nativeBuildInputs = [makeWrapper];

  buildPhase = ''
    runHook preBuild

    mkdir -p $out/bin
    cp ./time-ghc-modules $out/bin/time-ghc-modules
    wrapProgram $out/bin/time-ghc-modules --prefix PATH : ${lib.makeBinPath [ sqlite python3 coreutils findutils gnused ]} \
                                          --set PROCESS_SCRIPT $out/lib/process \
                                          --set HTML_FILE $out/lib/index.html

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib
    install -m 444 ./dist/index.html $out/lib
    install ./scripts/process $out/lib

    runHook postInstall
  '';

  meta = with lib; {
    description = "Analyze GHC .dump-timings files";
    homepage = "https://github.com/codedownio/time-ghc-modules";
    license = licenses.mit;
    maintainers = [ maintainers.thomasjm ];
    platforms = platforms.all;
  };
}
