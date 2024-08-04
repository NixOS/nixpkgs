{ lib, stdenv, fetchFromGitHub, perlPackages, shortenPerlShebang, texlive }:

let
  biberSource = texlive.pkgs.biber-ms.texsource;
  # missing test file
  multiscriptBltxml = (fetchFromGitHub {
    owner = "plk";
    repo = "biber";
    rev = "e8d056433063add7800f24589de76f89c4b64c20";
    hash = "sha256-QnN6Iyw6iOjfTX7DLVptsfAO/QNn9vOIk5IZlI15EvQ=";
  }) + "/t/tdata/multiscript.bltxml";
in

perlPackages.buildPerlModule {
  inherit (biberSource) pname version;

  src = "${biberSource}/source/bibtex/biber-ms/biblatex-biber-ms.tar.gz";

  # from META.json
  # (aliases in /* */ are replaced by the actual dependencies to prevent
  # evaluation errors with config.allowAliases = false)
  buildInputs = with perlPackages; [
    # build deps
    ConfigAutoConf ExtUtilsLibBuilder FileWhich TestDifferences
    /*TestMore=TestSimple=null*/
    # runtime deps
    BusinessISBN BusinessISMN BusinessISSN ClassAccessor DataCompare DataDump
    DataUniqid DateTimeCalendarJulian DateTimeFormatBuilder EncodeEUCJPASCII
    EncodeHanExtra EncodeJIS2K EncodeLocale FileSlurper IOString IPCRun3
    LWPProtocolHttps LWP/*LWPUserAgent*/ libwwwperl LinguaTranslit ListAllUtils
    ListMoreUtils ListMoreUtilsXS LogLog4perl MozillaCA ParseRecDescent
    PerlIOutf8_strict RegexpCommon SortKey TextBalanced TextBibTeX TextCSV
    TextCSV_XS TextRoman URI UnicodeLineBreak XMLLibXML XMLLibXMLSimple
    XMLLibXSLT XMLWriter autovivification
  ];
  nativeBuildInputs = lib.optional stdenv.isDarwin shortenPerlShebang;

  preConfigure = ''
    cp '${multiscriptBltxml}' t/tdata/multiscript.bltxml
  '';

  postInstall = ''
    mv "$out"/bin/biber{,-ms}
  '' + lib.optionalString stdenv.isDarwin ''
    shortenPerlShebang "$out"/bin/biber-ms
  '';

  meta = with lib; {
    description = "Backend for BibLaTeX (multiscript version)";
    license = biberSource.meta.license;
    platforms = platforms.unix;
    maintainers = [ maintainers.xworld21 ];
    mainProgram = "biber-ms";
  };
}
