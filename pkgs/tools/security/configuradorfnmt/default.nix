{ stdenv, fetchurl, makeDesktopItem, dpkg, bash, jre, pcsclite }:

stdenv.mkDerivation rec {
  pname = "configuradorfnmt";
  version = "1.0.1";

  src = fetchurl {
    i686-linux = {
      url = "https://descargas.cert.fnmt.es/Linux/configuradorfnmt_${version}-0_i386.deb";
      sha256 = "1g99gsv818wvj581b425svbnizjqqqw17bc70b3lkr8igbnpiilb";
    };
    x86_64-linux = {
      url = "https://descargas.cert.fnmt.es/Linux/configuradorfnmt_${version}-0_amd64.deb";
      sha256 = "0f7kfipmrmsahrr6p3783vdqq7vmgkjgqqgnznwjnlzj2y0gafhw";
    };
  }.${stdenv.hostPlatform.system};

  desktopItem = makeDesktopItem {
    name = "configuradorfnmt";
    desktopName = "Configurador FNMT";
    exec = "configuradorfnmt %u";
    icon = "configuradorfnmt";
    mimeType = "x-scheme-handler/fnmtcr;";
    categories = "Utility;";
  };

  buildInputs = [ bash jre pcsclite ];
  nativeBuildInputs = [ dpkg ];

  unpackPhase = "dpkg-deb -x $src .";

  installPhase = ''
    install -Dm644 usr/lib/configuradorfnmt/configuradorfnmt.jar $out/share/configuradorfnmt/configuradorfnmt.jar
    install -Dm644 usr/lib/configuradorfnmt/configuradorfnmt.png $out/share/pixmaps/configuradorfnmt.png

    install -d $out/bin
    cat > $out/bin/configuradorfnmt <<EOF
    #!${bash}/bin/sh
    ${jre}/bin/java -Dsun.security.smartcardio.library=${stdenv.lib.getLib pcsclite}/lib/libpcsclite.so.1 -jar $out/share/configuradorfnmt/configuradorfnmt.jar
    EOF
    chmod +x $out/bin/configuradorfnmt

    mkdir -p $out/share/applications
    ln -s ${desktopItem}/share/applications/* $out/share/applications/
  '';

  meta = with stdenv.lib; {
    description = "Tool to get keys and certificates from Spain's FNMT";
    homepage = "https://www.sede.fnmt.gob.es/descargas/descarga-software/instalacion-software-generacion-de-claves";
    license = licenses.unfree;
    platforms = [ "i686-linux" "x86_64-linux" ];
  };
}
