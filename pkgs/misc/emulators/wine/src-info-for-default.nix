{
  downloadPage = "http://www.winehq.org/";
  baseName = "wine";
  versionExtractorSedScript = ''s/[^-]*-(.+)[.]tar[.].*/\1/'';
  versionReferenceCreator = ''$(replaceAllVersionOccurences)'';
}
