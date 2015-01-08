{ stdenv, autoconf, automake, curl, fetchurl, jdk, jre, makeWrapper, nettools, python }:
with stdenv.lib;
stdenv.mkDerivation rec {
  name = "opentsdb-2.1.0-rc1";

  src = fetchurl {
    url = https://github.com/OpenTSDB/opentsdb/releases/download/v2.1.0RC1/opentsdb-2.1.0RC1.tar.gz;
    sha256 = "1vvhzdl2wgbzy2lvlyx40pks47ma6szs9ka4dwjf123xyixv0rmz";
  };

  buildInputs = [ autoconf automake curl jdk makeWrapper nettools python ];

  configurePhase = ''
    echo > build-aux/fetchdep.sh.in
    ./bootstrap
    mkdir build
    cd build
    ../configure --prefix=$out
    patchShebangs ../build-aux/
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
    maintainers = [ maintainers.ocharles ];
  };
}
