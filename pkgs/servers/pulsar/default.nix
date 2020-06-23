{ stdenv, fetchurl, jre, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "pulsar";
  version = "2.6.0";

  src = fetchurl {
    url = "mirror://apache/pulsar/${pname}-${version}/apache-${pname}-${version}-bin.tar.gz";
    sha256 = "0979nvv018brgyc3mn71sbm7yxxbid112lv85y5b8xh58vj96psv";
  };

  buildInputs = [ makeWrapper jre ];

  phases = ["unpackPhase" "installPhase"];

  installPhase = ''
    mkdir -p $out
    cp -R bin instances lib conf $out
    patchShebangs $out/bin
    for i in $out/bin/*; do
      if [ -f $i ]; then
        wrapProgram $i --set JAVA_HOME "${jre}"
      fi
    done
  '';

  meta = with stdenv.lib; {
    homepage = "https://pulsar.apache.org";
    description = "An open-source distributed pub-sub messaging system, part of the Apache Software Foundation";
    license = licenses.asl20;
    maintainers = with maintainers; [ samdroid-apps ];
    platforms = platforms.unix;
  };
}
