{
  downloadPage = "http://download.savannah.gnu.org/releases/liquidwar6/";
  choiceCommand = '' tail -1 | sed -r -e 's@(.*)/@http://download.savannah.gnu.org/releases/liquidwar6/\1/liquidwar6-\1.tar.gz@' '';
  sourceRegexp = ".*";
  baseName = "liquidwar";
  versionExtractorSedScript = ''s/.*-([-0-9a-z.]+)[.]tar[.]gz/\1/'';
  versionReferenceCreator = "$(replaceAllVersionOccurences)";
}
