{ stdenv, fetchurl, asciidoc, libxml2, docbook_xml_dtd_45, libxslt
, docbook_xsl, diffutils, coreutils, gnugrep
}:

stdenv.mkDerivation rec {
  name = "autorevision-${version}";
  version = "1.14";

  src = fetchurl {
    url = "https://github.com/Autorevision/autorevision/releases/download/v%2F${version}/autorevision-${version}.tgz";
    sha256 = "0h0ig922am9qd0nbri3i6p4k789mv5iavxzxwylclg0mfgx43qd2";
  };

  buildInputs = [
    asciidoc libxml2 docbook_xml_dtd_45 libxslt docbook_xsl
  ];

  installFlags = [ "prefix=$(out)" ];

  postInstall = ''
    sed -e "s|cmp|${diffutils}/bin/cmp|" \
        -e "s|cat|${coreutils}/bin/cat|" \
        -e "s|grep|${gnugrep}/bin/grep|" \
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
