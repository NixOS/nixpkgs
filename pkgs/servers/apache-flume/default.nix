{ stdenv, fetchurl, jre, makeWrapper, hadoop, majorVersion ? "1.9.0" }:

let
  versionMap = {
    "1.9.0" = {
      flumeVersion = "1.9.0";
      sha256 = "069nnakibv4pdra06fnq08nb7qypzx8j586r4fmw8kflpxdfswq3";
    };
  };
in

with versionMap.${majorVersion};

stdenv.mkDerivation rec {
  version = "${flumeVersion}";
  name = "apache-flume-${version}";

  src = fetchurl {
    url = "mirror://apache/flume/${version}/apache-flume-${version}-bin.tar.gz";
    inherit sha256;
  };

  buildInputs = [ hadoop jre makeWrapper ];

  installPhase = ''
    mkdir -p $out
    cp -R tools conf lib $out

    mkdir -p $out/bin
    cp bin/flume-ng $out/bin

    wrapProgram $out/bin/flume-ng \
      --set JAVA_HOME "${jre}" \
      --set FLUME_HOME "$out" \
      --set FLUME_JAVA_LIBRARY_PATH "${hadoop}/lib/native"
    chmod +x $out/bin\/*
  '';

  meta = with stdenv.lib; {
    homepage = http://flume.apache.org;
    description = "Flume is a distributed, reliable, and available service for efficiently collecting, aggregating, and moving large amounts of log data.";
    license = licenses.asl20;
    maintainers = [ ];
    platforms = platforms.unix;
  };

}
