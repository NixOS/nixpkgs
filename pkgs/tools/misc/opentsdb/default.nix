{ stdenv, autoconf, automake, fetchurl, curl, jdk, jre, makeWrapper, nettools, python }:
with stdenv.lib;
stdenv.mkDerivation rec {
  name = "opentsdb-2.1.0-rc1";

  src = fetchurl {
    url = https://github.com/OpenTSDB/opentsdb/archive/v2.1.0RC1.tar.gz;
    sha256 = "01li02j8kjanmas2gxkcz3gsn54nyfyvqdylxz3fqqjgg6y7hrm7";
  };

  buildInputs = [ autoconf automake curl jdk makeWrapper nettools python ];

  configurePhase = ''
    ./bootstrap
    mkdir build
    cd build
    ../configure --prefix=$out
  '';

  installPhase = ''
    make install
    wrapProgram $out/bin/tsdb \
      --set JAVA_HOME "${jre}" \
      --set JAVA "${jre}/bin/java"
  '';

  meta = with stdenv.lib; {
    description = "Time series database with millisecond precision";
    homepage = http://opentsdb.net;
    license = licenses.lgpl21Plus;
    platforms = stdenv.lib.platforms.linux;
  };
}
