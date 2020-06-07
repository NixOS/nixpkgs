{ stdenv, fetchurl, jre }:

stdenv.mkDerivation rec {
  pname = "sbt";
  version = "1.3.12";

  src = fetchurl {
    urls = [
      "https://piccolo.link/sbt-${version}.tgz"
      "https://github.com/sbt/sbt/releases/download/v${version}/sbt-${version}.tgz"
    ];
    sha256 = "0mwdqn0vk90wdpfzrbbc8l28407z5d62bvsi6jlgds2vbywjprxl";
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
    homepage = "https://www.scala-sbt.org/";
    license = licenses.bsd3;
    description = "A build tool for Scala, Java and more";
    maintainers = with maintainers; [ nequissimus ];
    platforms = platforms.unix;
  };
}
