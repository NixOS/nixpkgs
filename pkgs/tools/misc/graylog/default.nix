{ lib, stdenv, fetchurl, makeWrapper, openjdk11_headless, nixosTests }:

stdenv.mkDerivation rec {
  pname = "graylog";
  version = "4.0.8";

  src = fetchurl {
    url = "https://packages.graylog2.org/releases/graylog/graylog-${version}.tgz";
    sha256 = "sha256-1JlJNJSU1wJiztLhYD87YM/7p3YCBXBKerEo/xfumUg=";
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
    license     = licenses.gpl3;
    platforms   = platforms.unix;
    maintainers = [ maintainers.fadenb ];
  };
}
