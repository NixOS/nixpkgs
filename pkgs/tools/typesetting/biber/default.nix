{ stdenv, fetchFromGitHub, buildPerlPackage, autovivification, BusinessISBN
, BusinessISMN, BusinessISSN, ConfigAutoConf, DataCompare, DataDump, DateSimple
, EncodeEUCJPASCII, EncodeHanExtra, EncodeJIS2K, ExtUtilsLibBuilder
, FileSlurp, IPCRun3, Log4Perl, LWPProtocolHttps, ListAllUtils, ListMoreUtils
, ModuleBuild, MozillaCA, ReadonlyXS, RegexpCommon, TextBibTeX, UnicodeCollate
, UnicodeLineBreak, URI, XMLLibXMLSimple, XMLLibXSLT, XMLWriter, ClassAccessor
, TextRoman, DataUniqid, LinguaTranslit, UnicodeNormalize }:

let
  version = "2.5";
in
buildPerlPackage {
  name = "biber-${version}";
  src = fetchFromGitHub {
    owner = "plk";
    repo = "biber";
    rev = "v${version}";
    sha256 = "1ldkszsr2n11nib4nvmpvsxmvp0qd9w3lxijyqlf01cfaryjdzgr";
  };

  buildInputs = [
    autovivification BusinessISBN BusinessISMN BusinessISSN ConfigAutoConf
    DataCompare DataDump DateSimple EncodeEUCJPASCII EncodeHanExtra EncodeJIS2K
    ExtUtilsLibBuilder FileSlurp IPCRun3 Log4Perl LWPProtocolHttps ListAllUtils
    ListMoreUtils ModuleBuild MozillaCA ReadonlyXS RegexpCommon TextBibTeX
    UnicodeCollate UnicodeLineBreak URI XMLLibXMLSimple XMLLibXSLT XMLWriter
    ClassAccessor TextRoman DataUniqid LinguaTranslit UnicodeNormalize
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
