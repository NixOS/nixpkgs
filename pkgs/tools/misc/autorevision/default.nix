{ stdenv, fetchurl, asciidoc, libxml2, docbook_xml_dtd_45, libxslt
, docbook_xsl, diffutils, coreutils, gnugrep, gnused
}:

stdenv.mkDerivation rec {
  name = "autorevision-${version}";
  version = "1.21";

  src = fetchurl {
    url = "https://github.com/Autorevision/autorevision/releases/download/v%2F${version}/autorevision-${version}.tgz";
    sha256 = "07ssirjy2mgbqxr792n3rqa408hm7qnhwfjzd73rqfwvjcahy1q8";
  };

  buildInputs = [
    asciidoc libxml2 docbook_xml_dtd_45 libxslt docbook_xsl
  ];

  installFlags = [ "prefix=$(out)" ];

  postInstall = ''
    sed -e "s|\<cmp\>|${diffutils}/bin/cmp|g" \
        -e "s|\<cat\>|${coreutils}/bin/cat|g" \
        -e "s|\<grep\>|${gnugrep}/bin/grep|g" \
        -e "s|\<sed\>|${gnused}/bin/sed|g" \
        -e "s|\<tee\>|${coreutils}/bin/tee|g" \
        -i "$out/bin/autorevision"
  '';

  meta = with stdenv.lib; {
    description = "Extracts revision metadata from your VCS repository";
    homepage = https://autorevision.github.io/;
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = [ maintainers.bjornfor ];
  };
}
