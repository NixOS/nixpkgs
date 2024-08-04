{ lib, stdenv, fetchurl, jre_headless, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "trino-cli";
  version = "453";

  jarfilename = "${pname}-${version}-executable.jar";

  nativeBuildInputs = [ makeWrapper ];

  src = fetchurl {
    url = "mirror://maven/io/trino/${pname}/${version}/${jarfilename}";
    sha256 = "sha256-O2Wymv4V74dFv4Flj9GhNv3JWUWGjIwT3kA6mNGN8iM=";
  };

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    install -D "$src" "$out/share/java/${jarfilename}"

    makeWrapper ${jre_headless}/bin/java $out/bin/trino \
      --add-flags "-jar $out/share/java/${jarfilename}"

    runHook postInstall
  '';

  meta = with lib; {
    description = "Trino CLI provides a terminal-based, interactive shell for running queries";
    mainProgram = "trino";
    homepage = "https://github.com/trinodb/trino";
    license = licenses.asl20;
    maintainers = with maintainers; [ regadas cpcloud ];
  };
}
