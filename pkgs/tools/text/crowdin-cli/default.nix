{ lib
, stdenv
, fetchurl
, gawk
, git
, gnugrep
, installShellFiles
, jre
, makeWrapper
, unzip
}:

stdenv.mkDerivation rec {
  pname = "crowdin-cli";
  version = "3.6.5";

  src = fetchurl {
    url = "https://github.com/crowdin/${pname}/releases/download/${version}/${pname}.zip";
    sha256 = "sha256-9bw85dFazlcbZhx/bUoxW4iIsw+RdE3d+O5Cj3Obb7A=";
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

  meta = with lib; {
    homepage = "https://github.com/crowdin/crowdin-cli/";
    description = "A command-line client for the Crowdin API";
    license = licenses.mit;
    maintainers = with maintainers; [ DamienCassou ];
  };
}
