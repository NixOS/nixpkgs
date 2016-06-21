{ stdenv, fetchurl, buildPerlPackage, autovivification, BusinessISBN
, BusinessISMN, BusinessISSN, ConfigAutoConf, DataCompare, DataDump, DateSimple
, EncodeEUCJPASCII, EncodeHanExtra, EncodeJIS2K, ExtUtilsLibBuilder
, FileSlurp, IPCRun3, Log4Perl, LWPProtocolHttps, ListAllUtils, ListMoreUtils
, ModuleBuild, MozillaCA, ReadonlyXS, RegexpCommon, TextBibTeX, UnicodeCollate
, UnicodeLineBreak, URI, XMLLibXMLSimple, XMLLibXSLT, XMLWriter, ClassAccessor
, TextRoman, DataUniqid }:

let
  version = "2.4";
  pn = "biblatex-biber";
in
buildPerlPackage {
  name = "biber-${version}";
  src = fetchurl {
    url = "mirror://sourceforge/project/${pn}/${pn}/${version}/${pn}.tar.gz";
    sha256 = "1gccbs5vzs3fca41d9dwl6nrdljnh29yls8xzfw04hd57yrfn5w4";
  };

  buildInputs = [
    autovivification BusinessISBN BusinessISMN BusinessISSN ConfigAutoConf
    DataCompare DataDump DateSimple EncodeEUCJPASCII EncodeHanExtra EncodeJIS2K
    ExtUtilsLibBuilder FileSlurp IPCRun3 Log4Perl LWPProtocolHttps ListAllUtils
    ListMoreUtils ModuleBuild MozillaCA ReadonlyXS RegexpCommon TextBibTeX
    UnicodeCollate UnicodeLineBreak URI XMLLibXMLSimple XMLLibXSLT XMLWriter
    ClassAccessor TextRoman DataUniqid
  ];
  preConfigure = "touch Makefile.PL";
  buildPhase = "perl Build.PL --prefix=$out; ./Build build";
  checkPhase = "./Build test";
  installPhase = "./Build install";

  # Tests seem to be broken
  doCheck = false;

  meta = {
    description = "Backend for BibLaTeX";
    license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.ttuegel ];
  };
}
