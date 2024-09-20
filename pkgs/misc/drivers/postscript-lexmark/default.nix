{ lib, stdenv, fetchurl, rpmextract }:
let
  version = "20160218";
in
stdenv.mkDerivation {
  pname = "postscript-lexmark";
  inherit version;

  src = fetchurl {
    url = "https://www.openprinting.org/download/printdriver/components/lsb3.2/main/RPMS/noarch/openprinting-ppds-postscript-lexmark-${version}-1lsb3.2.noarch.rpm";
    sha256 = "0wbhvypdr96a5ddg6kj41dn9sbl49n7pfi2vs762ij82hm2gvwcm";
  };

  nativeBuildInputs = [ rpmextract ];

  sourceRoot = ".";

  unpackPhase = ''
    rpmextract $src
    for ppd in opt/OpenPrinting-Lexmark/ppds/Lexmark/*; do
      gzip -d $ppd
    done
  '';

  installPhase = ''
    mkdir -p $out/share/cups/model/postscript-lexmark
    cp opt/OpenPrinting-Lexmark/ppds/Lexmark/*.ppd $out/share/cups/model/postscript-lexmark/
    cp -r opt/OpenPrinting-Lexmark/doc $out/doc
  '';

  meta = with lib; {
    homepage = "https://www.openprinting.org/driver/Postscript-Lexmark/";
    description = "Lexmark Postscript Drivers";
    platforms = platforms.linux;
  };
}
