{ stdenv, fetchurl, jre, autoPatchelfHook, zlib }:

stdenv.mkDerivation rec {
  pname = "sbt";
  version = "1.4.0";

  src = fetchurl {
    url =
      "https://github.com/sbt/sbt/releases/download/v${version}/sbt-${version}.tgz";
    sha256 = "1mgfs732w1c1p7dna7h47x8h073lvjs224fqlpkkvq10153mnxxl";
  };

  patchPhase = ''
    echo -java-home ${jre.home} >>conf/sbtopts
  '';

  nativeBuildInputs = [ autoPatchelfHook ];

  buildInputs = [ zlib ];

  installPhase = ''
    mkdir -p $out/share/sbt $out/bin
    cp -ra . $out/share/sbt
    ln -sT ../share/sbt/bin/sbt $out/bin/sbt
    ln -sT ../share/sbt/bin/sbtn-x86_64-${
      if (stdenv.isDarwin) then "apple-darwin" else "pc-linux"
    } $out/bin/sbtn
  '';

  meta = with stdenv.lib; {
    homepage = "https://www.scala-sbt.org/";
    license = licenses.bsd3;
    description = "A build tool for Scala, Java and more";
    maintainers = with maintainers; [ nequissimus ];
    platforms = platforms.unix;
  };
}
