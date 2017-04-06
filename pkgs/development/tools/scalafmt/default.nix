{ stdenv, fetchurl, unzip, jre }:

stdenv.mkDerivation rec {
  version = "0.6.7";
  baseName = "scalafmt";
  name = "${baseName}-${version}";

  src = fetchurl {
    url = "https://github.com/scalameta/scalafmt/releases/download/v${version}/${baseName}.tar.gz";
    sha256 = "122x4a5x8024s7qqqs7vx8kz1x18q2l6alcvpzvsqkc304ybhfmh";
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
