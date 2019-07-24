{ stdenv, fetchurl, jre8, bash, coreutils }:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "apache-pulsar-${version}";
  version = "2.4.0";

  src = fetchurl {
    url = "https://www.apache.org/dyn/mirrors/mirrors.cgi?action=download&filename=pulsar/pulsar-2.4.0/apache-pulsar-2.4.0-bin.tar.gz";
    sha256 = "bb733d651382e36166f3b96f1cc4b13242a88ac325df305b693b0266795e73ec";
  };

  buildInputs = [ jre8 bash coreutils ];
  # makeFlags = "PREFIX=$(out)";

  installPhase = ''
    mkdir -p $out
    mkdir -p $out/bin
    cp bin/pulsar* $out/bin
    chmod +x $out/bin\/*
  '';

  meta = with stdenv.lib; {
    homepage = https://pulsar.apache.org;
    description = "Apache Pulsar is an open-source distributed pub-sub messaging";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = [ maintainers.alahmedse ];
  };
}
