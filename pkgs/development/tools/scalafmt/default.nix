{ stdenv, fetchurl, unzip, jre }:

stdenv.mkDerivation rec {
  version = "0.4.10";
  baseName = "scalafmt";
  name = "${baseName}-${version}";

  src = fetchurl {
    url = "https://github.com/olafurpg/scalafmt/releases/download/v${version}/${baseName}.tar.gz";
    sha256 = "0igz95zy69pasvj4vya71akhwlc0233m7kwrn66rali1wxs2kcsz";
  };

  unpackPhase = "tar xvzf $src";

  installPhase = ''
    mkdir -p "$out/bin"
    mkdir -p "$out/lib"

    cp cli/target/scala-2.11/scalafmt.jar "$out/lib/${name}.jar"

    cat > "$out/bin/${baseName}" << EOF
    #!${stdenv.shell}
    exec ${jre}/bin/java -jar "$out/lib/${name}.jar" "\$@"
    EOF

    chmod a+x "$out/bin/${baseName}"
  '';

  meta = with stdenv.lib; {
    description = "Opinionated code formatter for Scala";
    homepage = http://scalafmt.org;
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = [ maintainers.markus1189 ];
  };
}
