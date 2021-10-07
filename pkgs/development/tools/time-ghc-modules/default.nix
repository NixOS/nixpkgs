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
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "codedownio";
    repo = "time-ghc-modules";
    rev = version;
    sha256 = "sha256:1fa1lz0r8s8q664z4303y3b9jqa6d7wv53bnh7pifj0fm45xqznp";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [makeWrapper];

  buildPhase = ''
    runHook preBuild

    mkdir -p $out/bin
    cp ./time-ghc-modules $out/bin/time-ghc-modules
    wrapProgram $out/bin/time-ghc-modules --prefix PATH : ${lib.makeBinPath [ sqlite python3 coreutils findutils gnused ]}

    mkdir -p $out/bin/scripts
    cp ./scripts/process $out/bin/scripts/process

    mkdir -p $out/bin/dist
    cp ./dist/index.html $out/bin/dist/index.html

    runHook postBuild
  '';

  dontInstall = true;

  meta = with lib; {
    description = "Analyze GHC .dump-timings files";
    homepage = "https://github.com/codedownio/time-ghc-modules";
    license = licenses.mit;
    maintainers = [ maintainers.thomasjm ];
    platforms = platforms.all;
  };
}
