{ stdenv, fetchurl, buildPerlPackage, autovivification, BusinessISBN
, BusinessISMN, BusinessISSN, ConfigAutoConf, DataCompare, DataDump, DateSimple
, EncodeEUCJPASCII, EncodeHanExtra, EncodeJIS2K, ExtUtilsLibBuilder
, FileSlurp, IPCRun3, Log4Perl, LWPProtocolHttps, ListAllUtils, ListMoreUtils
, ModuleBuild, MozillaCA, ReadonlyXS, RegexpCommon, TextBibTeX, UnicodeCollate
, UnicodeLineBreak, URI, XMLLibXMLSimple, XMLLibXSLT, XMLWriter }:

let
  version = "1.9";
  pn = "biblatex-biber";
in
buildPerlPackage {
  name = "biber-${version}";
  src = fetchurl {
    url = "mirror://sourceforge/project/${pn}/${pn}/${version}/${pn}.tar.gz";
    sha256 = "1a3iq7l9i54f8nfzjmp1qdb6aqm7977q1g4san470010fkfbvjdc";
  };

  buildInputs = [
    autovivification BusinessISBN BusinessISMN BusinessISSN ConfigAutoConf
    DataCompare DataDump DateSimple EncodeEUCJPASCII EncodeHanExtra EncodeJIS2K
    ExtUtilsLibBuilder FileSlurp IPCRun3 Log4Perl LWPProtocolHttps ListAllUtils
    ListMoreUtils ModuleBuild MozillaCA ReadonlyXS RegexpCommon TextBibTeX
    UnicodeCollate UnicodeLineBreak URI XMLLibXMLSimple XMLLibXSLT XMLWriter
  ];
  preConfigure = "touch Makefile.PL";
  buildPhase = "perl Build.PL --prefix=$out; ./Build build";
  checkPhase = "./Build test";
  installPhase = "./Build install";

  # Tests seem to be broken
  doCheck = false;

  meta = {
    description = "Backend for BibLaTeX";
    license = "perl";
    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.ttuegel ];
  };
}
