{ lib, stdenv, fetchurl, perlPackages, makeWrapper, zip, libxslt }:

stdenv.mkDerivation rec {
  pname = "docbook2odf";
  version = "0.244";

  src = fetchurl {
    url = "http://open.comsultia.com/docbook2odf/dwn/docbook2odf-${version}.tar.gz";
    sha256 = "10k44g0qqa37k30pfj8vz95j6zdzz0nmnqjq1lyahfs2h4glzgwb";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ perlPackages.perl ];

  installPhase = ''
    mkdir -p "$out/bin/"
    mkdir -p "$out/share/docbook2odf/"
    mkdir -p "$out/share/doc/docbook2odf/"
    mkdir -p "$out/share/man/man1/"
    mkdir -p "$out/share/applications/"

    cp utils/docbook2odf "$out/bin/"
    cp docs/docbook2odf.1 "$out/share/man/man1/"
    cp -r examples/ "$out/share/doc/docbook2odf/"
    cp -r xsl/ "$out/share/docbook2odf/"
    cp bindings/desktop/docbook2odf.desktop "$out/share/applications/"

    sed -i "s|/usr/share/docbook2odf|$out/share/docbook2odf|" "$out/bin/docbook2odf"

    wrapProgram "$out/bin/docbook2odf" \
      --prefix PATH : "${lib.makeBinPath [ zip libxslt ]}" \
      --prefix PERL5PATH : "${perlPackages.makePerlPath [ perlPackages.ImageMagick ]}"
  '';

  meta = with lib; {
    description = "Convert DocBook to OpenDocument Format (ODF)";
    longDescription = ''
      Docbook2odf is a toolkit that automatically converts DocBook to OASIS
      OpenDocument (ODF, the ISO standardized format used for texts,
      spreadsheets and presentations). Conversion is based on a XSLT which
      makes it easy to convert DocBook->ODF, ODT, ODS and ODP as all these
      documents are XML based.
    '';
    homepage = "http://open.comsultia.com/docbook2odf/";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };
}
