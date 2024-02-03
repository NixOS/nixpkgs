{ lib, stdenv, fetchurl, jre }:

stdenv.mkDerivation rec {
  pname = "ditaa";
  version = "0.11.0";

  src = fetchurl {
    url = "https://github.com/stathissideris/ditaa/releases/download/v${version}/ditaa-${version}-standalone.jar";
    sha256 = "1acnl7khz8aasg230nbsx9dyf8716scgb5l3679cb2bdzxisl64l";
  };

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/bin $out/lib

    cp ${src} "$out/lib/ditaa.jar"

    cat > "$out/bin/ditaa" << EOF
    #!${stdenv.shell}
    exec ${jre}/bin/java -jar "$out/lib/ditaa.jar" "\$@"
    EOF

    chmod a+x "$out/bin/ditaa"
  '';

  meta = with lib; {
    description = "Convert ascii art diagrams into proper bitmap graphics";
    homepage = "https://github.com/stathissideris/ditaa";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.lgpl3;
    platforms = platforms.unix;
    maintainers = [ maintainers.bjornfor ];
    mainProgram = "ditaa";
  };
}
