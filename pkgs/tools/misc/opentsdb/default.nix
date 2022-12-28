{ lib, stdenv, autoconf, automake, curl, fetchurl, fetchpatch, jdk8, makeWrapper, nettools
, python3, git
}:

let jdk = jdk8; jre = jdk8.jre; in

stdenv.mkDerivation rec {
  pname = "opentsdb";
  version = "2.4.0";

  src = fetchurl {
    url = "https://github.com/OpenTSDB/opentsdb/releases/download/v${version}/${pname}-${version}.tar.gz";
    sha256 = "0b0hilqmgz6n1q7irp17h48v8fjpxhjapgw1py8kyav1d51s7mm2";
  };

  patches = [
    (fetchpatch {
      name = "CVE-2020-35476.patch";
      url = "https://github.com/OpenTSDB/opentsdb/commit/b89fded4ee326dc064b9d7e471e9f29f7d1dede9.patch";
      sha256 = "1vb9m0a4fsjqcjagiypvkngzgsw4dil8jrlhn5xbz7rwx8x96wvb";
    })
  ];

  nativeBuildInputs = [ makeWrapper autoconf automake ];
  buildInputs = [ curl jdk nettools python3 git ];

  preConfigure = ''
    patchShebangs ./build-aux/
    ./bootstrap
  '';

  postInstall = ''
    wrapProgram $out/bin/tsdb \
      --set JAVA_HOME "${jre}" \
      --set JAVA "${jre}/bin/java"
  '';

  meta = with lib; {
    description = "Time series database with millisecond precision";
    homepage = "http://opentsdb.net";
    license = licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
    maintainers = [ ];
  };
}
