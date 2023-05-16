{ lib
, stdenv
, fetchurl
, gawk
, git
, gnugrep
, installShellFiles
, jre
, makeWrapper
, crowdin-cli
, testers
, unzip
}:

stdenv.mkDerivation rec {
  pname = "crowdin-cli";
<<<<<<< HEAD
  version = "3.14.0";

  src = fetchurl {
    url = "https://github.com/crowdin/${pname}/releases/download/${version}/${pname}.zip";
    hash = "sha256-Yb4zORtmEgZGu9h05/t4sQ6eTljHba89JZKh7vzIp2Q=";
=======
  version = "3.11.0";

  src = fetchurl {
    url = "https://github.com/crowdin/${pname}/releases/download/${version}/${pname}.zip";
    sha256 = "sha256-qT0vEqUISprR1pOPaO3r/HHA/Zt07Af/0WyY950MEgI=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ installShellFiles makeWrapper unzip ];

  installPhase = ''
    runHook preInstall

    install -D crowdin-cli.jar $out/lib/crowdin-cli.jar

    installShellCompletion --cmd crowdin --bash ./crowdin_completion

    makeWrapper ${jre}/bin/java $out/bin/crowdin \
      --argv0 crowdin \
      --add-flags "-jar $out/lib/crowdin-cli.jar" \
      --prefix PATH : ${lib.makeBinPath [ gawk gnugrep git ]}

    runHook postInstall
  '';

  passthru.tests.version = testers.testVersion { package = crowdin-cli; };

  meta = with lib; {
    mainProgram = "crowdin";
    homepage = "https://github.com/crowdin/crowdin-cli/";
    description = "A command-line client for the Crowdin API";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.mit;
    maintainers = with maintainers; [ DamienCassou ];
  };
}
