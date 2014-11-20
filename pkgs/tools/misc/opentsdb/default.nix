{ stdenv, fetchurl, curl, jdk, jre, makeWrapper, nettools, python }:
with stdenv.lib;
stdenv.mkDerivation rec {
  name = "opentsdb-2.0.1";

  src = fetchurl {
    url = https://github.com/OpenTSDB/opentsdb/releases/download/v2.0.1/opentsdb-2.0.1.tar.gz;
    sha256 = "1q2gkl72yjzd8yrggl0018m9s8mc9zwnz3d8ias54vqh3irypc2c";
  };

  buildPhase = "find .";

  buildInputs = [ curl jdk makeWrapper nettools python ];

  installPhase = ''
    make install
    wrapProgram $out/bin/tsdb \
      --set JAVA_HOME "${jre}" \
      --set JAVA "${jre}/bin/java"
  '';
}
