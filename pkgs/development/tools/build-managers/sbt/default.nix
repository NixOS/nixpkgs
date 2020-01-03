{ stdenv, fetchurl, jre }:

stdenv.mkDerivation rec {
  pname = "sbt";
  version = "1.3.5";

  src = fetchurl {
    urls = [
      "https://piccolo.link/sbt-${version}.tgz"
      "https://github.com/sbt/sbt/releases/download/v${version}/sbt-${version}.tgz"
    ];
    sha256 = "1c1ha4w3c36l7w2ncmwvry05hwcj8pv7dkpq23wdc25w1yj0l7sn";
  };

  patchPhase = ''
    echo -java-home ${jre.home} >>conf/sbtopts
  '';

  installPhase = ''
    mkdir -p $out/share/sbt $out/bin
    cp -ra . $out/share/sbt
    ln -s $out/share/sbt/bin/sbt $out/bin/
  '';

  meta = with stdenv.lib; {
    homepage = https://www.scala-sbt.org/;
    license = licenses.bsd3;
    description = "A build tool for Scala, Java and more";
    maintainers = with maintainers; [ nequissimus ];
    platforms = platforms.unix;
  };
}
