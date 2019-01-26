{ stdenv, fetchgit, libxml2, libxslt, docbook-xsl, docbook_xml_dtd_44, perlPackages, makeWrapper, darwin }:

with stdenv.lib;
stdenv.mkDerivation rec {
  name = "moreutils-${version}";
  version = "0.62";

  src = fetchgit {
    url = "git://git.joeyh.name/moreutils";
    rev = "refs/tags/${version}";
    sha256 = "0sk7rgqsqbdwr69mh7y4v9lv4v0nfmsrqgvbpy2gvy82snhfzar2";
  };

  preBuild = ''
    substituteInPlace Makefile --replace /usr/share/xml/docbook/stylesheet/docbook-xsl ${docbook-xsl}/xml/xsl/docbook
  '';

  buildInputs = [ libxml2 libxslt docbook-xsl docbook_xml_dtd_44 makeWrapper ]
    ++ optional stdenv.isDarwin darwin.cctools;

  propagatedBuildInputs = with perlPackages; [ perl IPCRun TimeDate TimeDuration ];

  buildFlags = "CC=cc";
  installFlags = "PREFIX=$(out)";

  postInstall = "wrapProgram $out/bin/chronic --prefix PERL5LIB : $PERL5LIB";

  meta = {
    description = "Growing collection of the unix tools that nobody thought to write long ago when unix was young";
    homepage = https://joeyh.name/code/moreutils/;
    maintainers = with maintainers; [ koral pSub ];
    platforms = platforms.all;
    license = licenses.gpl2Plus;
  };
}
