{ lib, stdenv, fetchurl, makeWrapper, openjdk11_headless, nixosTests }:

stdenv.mkDerivation rec {
  pname = "graylog";
  version = "3.3.16";

  src = fetchurl {
    url = "https://packages.graylog2.org/releases/graylog/graylog-${version}.tgz";
    sha256 = "sha256-P/cnfYKnMSnDD4otEyirKlLaFduyfSO9sao4BY3c3Z4=";
  };

  dontBuild = true;
  dontStrip = true;

  nativeBuildInputs = [ makeWrapper ];
  makeWrapperArgs = [ "--set-default" "JAVA_HOME" "${openjdk11_headless}" ];

  passthru.tests = { inherit (nixosTests) graylog; };

  installPhase = ''
    mkdir -p $out
    cp -r {graylog.jar,lib,bin,plugin} $out
    wrapProgram $out/bin/graylogctl $makeWrapperArgs
  '';

  meta = with lib; {
    description = "Open source log management solution";
    homepage    = "https://www.graylog.org/";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license     = licenses.gpl3;
    maintainers = [ maintainers.fadenb ];
    mainProgram = "graylogctl";
    platforms   = platforms.unix;
  };
}
