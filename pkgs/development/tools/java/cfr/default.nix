{ stdenv, fetchurl, jre }:

stdenv.mkDerivation rec {
  name = "cfr-${version}";
  version = "0_101";

  src = fetchurl {
    sha256 = "0zwl3whypdm2qrw3hwaqjnifkb4wcdn8fx9scrjkli54bhr6dqch";
    url = "http://www.benf.org/other/cfr/cfr_${version}.jar";
  };

  buildInputs = [ jre ];

  phases = [ "installPhase" ];

  installPhase = ''
    jar=$out/share/cfr/cfr_${version}.jar

    install -Dm644 ${src} $jar

    cat << EOF > cfr
    #!${stdenv.shell}
    exec ${jre}/bin/java -jar $jar "\''${@}"
    EOF
    install -Dm755 cfr $out/bin/cfr
  '';

  meta = with stdenv.lib; {
    description = "Another java decompiler";
    longDescription = ''
      CFR will decompile modern Java features - Java 8 lambdas (pre and post
      Java beta 103 changes), Java 7 String switches etc, but is written
      entirely in Java 6.
    '';
    homepage = http://www.benf.org/other/cfr/;
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ nckx ];
  };
}
