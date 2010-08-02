{
  downloadPage = "http://4store.org/download/";
  baseName = "4store";
  choiceCommand = "tail -n 1";
  versionExtractorSedScript = "s@.*-(v[0-9.]+)[.].*@\\1@";
}
