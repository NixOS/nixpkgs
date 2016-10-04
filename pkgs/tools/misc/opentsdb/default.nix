{ stdenv, autoconf, automake, curl, fetchurl, jdk, jre, makeWrapper, nettools, python }:
with stdenv.lib;
stdenv.mkDerivation rec {
  name = "opentsdb-${version}";
  version = "2.2.0";

  src = fetchurl {
    url = "https://github.com/OpenTSDB/opentsdb/releases/download/v${version}/${name}.tar.gz";
    sha256 = "1dfzfsagpviqbifz81pik7pzvadz71kls1idi7jiq7z27vcd92an";
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
