{ stdenv, autoconf, automake, curl, fetchurl, jdk, jre, makeWrapper, nettools
, python, git
}:

with stdenv.lib;

stdenv.mkDerivation rec {
  pname = "opentsdb";
  version = "2.4.0";

  src = fetchurl {
    url = "https://github.com/OpenTSDB/opentsdb/releases/download/v${version}/${pname}-${version}.tar.gz";
    sha256 = "0b0hilqmgz6n1q7irp17h48v8fjpxhjapgw1py8kyav1d51s7mm2";
  };

  buildInputs = [ autoconf automake curl jdk makeWrapper nettools python git ];

  preConfigure = ''
    patchShebangs ./build-aux/
    ./bootstrap
  '';

  postInstall = ''
    wrapProgram $out/bin/tsdb \
      --set JAVA_HOME "${jre}" \
      --set JAVA "${jre}/bin/java"
  '';

  meta = with stdenv.lib; {
    description = "Time series database with millisecond precision";
    homepage = http://opentsdb.net;
    license = licenses.lgpl21Plus;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ maintainers.ocharles ];
  };
}
