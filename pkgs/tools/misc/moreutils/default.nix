{ stdenv, fetchurl, libxml2, libxslt, docbook-xsl, perl, IPCRun, TimeDate, TimeDuration, makeWrapper }:

with stdenv.lib;
stdenv.mkDerivation rec {
  name = "moreutils-${version}";
  version = "0.54";

  src = fetchurl {
    url = "http://ftp.de.debian.org/debian/pool/main/m/moreutils/moreutils_${version}.orig.tar.gz";
    sha256 = "17sj7d4l69gc7l17awwvq44rl137qc0lmi41z04apj5vdd6iqa2h";
  };

  preBuild = ''
    substituteInPlace Makefile --replace /usr/share/xml/docbook/stylesheet/docbook-xsl ${docbook-xsl}/xml/xsl/docbook
  '';

  buildInputs = [ libxml2 libxslt docbook-xsl makeWrapper ];

  propagatedBuildInputs = [ perl IPCRun TimeDate TimeDuration ];

  installFlags = "PREFIX=$(out)";

  postInstall = "wrapProgram $out/bin/chronic --prefix PERL5LIB : $PERL5LIB";

  meta = {
    description = "Growing collection of the unix tools that nobody thought to write long ago when unix was young.";
    homepage = https://joeyh.name/code/moreutils/;
    maintainers = with maintainers; [ koral ];
  };
}
