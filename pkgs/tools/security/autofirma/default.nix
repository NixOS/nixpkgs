{ stdenv, fetchurl, makeDesktopItem, unzip, dpkg, bash, jre8 }:

stdenv.mkDerivation rec {
  pname = "autofirma";
  version = "1.6.5";

  src = fetchurl {
    url = "https://estaticos.redsara.es/comunes/autofirma/currentversion/AutoFirma_Linux.zip";
    sha256 = "1zys8sl03fbh9w8b2kv7xldfsrz53yrhjw3yn45bdxzpk7yh4f5j";
  };

  desktopItem = makeDesktopItem {
    name = "AutoFirma";
    desktopName = "AutoFirma";
    exec = "AutoFirma %u";
    icon = "AutoFirma";
    mimeType = "x-scheme-handler/afirma;";
    categories = "Office;";
  };

  buildInputs = [ bash jre8 ];
  nativeBuildInputs = [ unzip dpkg jre8 ];

  unpackPhase = ''
    unzip $src AutoFirma_${builtins.replaceStrings ["."] ["_"] version}.deb
    dpkg-deb -x AutoFirma_${builtins.replaceStrings ["."] ["_"] version}.deb .
  '';

  buildPhase = ''
    ${jre8}/bin/java -jar usr/lib/AutoFirma/AutoFirmaConfigurador.jar
  '';

  installPhase = ''
    install -Dm644 usr/lib/AutoFirma/AutoFirma.jar $out/share/AutoFirma/AutoFirma.jar
    install -Dm644 usr/lib/AutoFirma/AutoFirmaConfigurador.jar $out/share/AutoFirma/AutoFirmaConfigurador.jar
    install -Dm644 usr/share/AutoFirma/AutoFirma.svg $out/share/AutoFirma/AutoFirma.svg
    install -Dm644 usr/lib/AutoFirma/AutoFirma.png $out/share/pixmaps/AutoFirma.png

    install -d $out/bin
    cat > $out/bin/AutoFirma <<EOF
    #!${bash}/bin/sh
    ${jre8}/bin/java -jar $out/share/AutoFirma/AutoFirma.jar $*
    EOF
    chmod +x $out/bin/AutoFirma

    install -Dm644 usr/lib/AutoFirma/AutoFirma_ROOT.cer $out/share/ca-certificates/trust-source/anchors/AutoFirma_ROOT.cer

    mkdir -p $out/share/applications
    ln -s ${desktopItem}/share/applications/* $out/share/applications/
  '';

  meta = with stdenv.lib; {
    description = "Spanish Government digital signature tool";
    homepage = "https://firmaelectronica.gob.es/Home/Ciudadanos/Aplicaciones-Firma.html";
    license = with licenses; [ gpl2Only eupl11 ];
    platforms = platforms.linux;
  };
}
