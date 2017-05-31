{ stdenv, fetchurl, unzip, jre }:

stdenv.mkDerivation rec {
  name = "ditaa-0.9";

  src = fetchurl {
    name = "${name}.zip";
    url = "mirror://sourceforge/project/ditaa/ditaa/0.9/ditaa0_9.zip";
    sha256 = "12g6k3hacvyw3s9pijli7vfnkspyp37qkr29qgbmq1hbp0ryk2fn";
  };

  buildInputs = [ unzip ];

  phases = [ "installPhase" ];

  installPhase = ''
    unzip "$src"
    
    mkdir -p "$out/bin"
    mkdir -p "$out/lib"
    mkdir -p "$out/share/ditaa"

    cp dita*.jar "$out/lib/ditaa.jar"
    cp COPYING HISTORY "$out/share/ditaa"

    cat > "$out/bin/ditaa" << EOF
    #!${stdenv.shell}
    exec ${jre}/bin/java -jar "$out/lib/ditaa.jar" "\$@"
    EOF

    chmod a+x "$out/bin/ditaa"
  '';

  meta = with stdenv.lib; {
    description = "Convert ascii art diagrams into proper bitmap graphics";
    homepage = http://ditaa.sourceforge.net/;
    license = licenses.gpl2;
    platforms = platforms.unix;
    maintainers = [ maintainers.bjornfor ];
  };
}
