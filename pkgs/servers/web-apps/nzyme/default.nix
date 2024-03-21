{ stdenv, lib, fetchurl, jre }:
stdenv.mkDerivation rec {
  pname = "nzyme";
  version = "1.1.1";

  src = fetchurl {
    url = "https://assets.nzyme.org/releases/${pname}-${version}.jar";
    sha256 = "1ygbblgqqwad389g2szabdacc218b4bvm240fk4l73x7w8halr9b";
  };

  buildPhase = ''
    jar=$src

    mkdir -p $out/share/java
    cp $jar $out/share/java/nzyme.jar

    mkdir -p $out/bin
    cat > $out/bin/nzyme <<EOF
    #! $SHELL -e
    exec $jre/bin/java -jar $out/share/java/nzyme.jar --config-file \$1
    EOF
    chmod +x $out/bin/nzyme
  '';

  inherit jre;
  dontInstall = true;
  dontUnpack = true;

  meta = with lib; {
    homepage = "https://www.nzyme.org/";
    description = "A program to detect attacks against wireless networks";
    license = licenses.sspl;
    maintainers = with maintainers; [ jakobu5 ];
  };
}
