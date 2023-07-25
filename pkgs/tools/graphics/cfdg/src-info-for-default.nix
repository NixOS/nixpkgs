{
  downloadPage = "https://contextfreeart.org/mediawiki/index.php/Download_page";
  baseName = "cfdg";
  sourceRegexp = ".*[.]tgz";
  versionExtractorSedScript = ''s/[^0-9]*([0-9.]*)[.]tgz/\1/'';
}
