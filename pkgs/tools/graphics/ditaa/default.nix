{ stdenv, fetchurl, jre }:

stdenv.mkDerivation rec {
  name = "ditaa-0.11.0";

  src = fetchurl {
    url = "https://github.com/stathissideris/ditaa/releases/download/v0.11.0/ditaa-0.11.0-standalone.jar";
    sha256 = "1acnl7khz8aasg230nbsx9dyf8716scgb5l3679cb2bdzxisl64l";
  };

  phases = [ "installPhase" ];

  installPhase = ''
    mkdir -p "$out/bin"
    mkdir -p "$out/lib"

    cp ${src} "$out/lib/ditaa.jar"

    cat > "$out/bin/ditaa" << EOF
    #!${stdenv.shell}
    exec ${jre}/bin/java -jar "$out/lib/ditaa.jar" "\$@"
    EOF

    chmod a+x "$out/bin/ditaa"
  '';

  meta = with stdenv.lib; {
    description = "Convert ascii art diagrams into proper bitmap graphics";
    homepage = "https://github.com/stathissideris/ditaa";
    license = licenses.lgpl3;
    platforms = platforms.unix;
    maintainers = [ maintainers.bjornfor ];
  };
}
