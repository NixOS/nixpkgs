{ stdenv, fetchurl, libxml2, libxslt, docbook-xsl, docbook_xml_dtd_44, perl, IPCRun, TimeDate, TimeDuration, makeWrapper }:

with stdenv.lib;
stdenv.mkDerivation rec {
  name = "moreutils-${version}";
  version = "0.59";

  src = fetchurl {
    url = "http://ftp.de.debian.org/debian/pool/main/m/moreutils/moreutils_${version}.orig.tar.gz";
    sha256 = "1d6ik3j4lwp90vb93p7yv60k6vk2chz448d1z9xrmxvv371i33m4";
  };

  preBuild = ''
    substituteInPlace Makefile --replace /usr/share/xml/docbook/stylesheet/docbook-xsl ${docbook-xsl}/xml/xsl/docbook
  '';

  buildInputs = [ libxml2 libxslt docbook-xsl docbook_xml_dtd_44 makeWrapper ];

  propagatedBuildInputs = [ perl IPCRun TimeDate TimeDuration ];

  installFlags = "PREFIX=$(out)";

  postInstall = "wrapProgram $out/bin/chronic --prefix PERL5LIB : $PERL5LIB";

  meta = {
    description = "Growing collection of the unix tools that nobody thought to write long ago when unix was young";
    homepage = https://joeyh.name/code/moreutils/;
    maintainers = with maintainers; [ koral ];
    platforms = platforms.all;
  };
}
