{
  downloadPage = "http://sourceforge.net/projects/webdruid/files/";
  choiceCommand = ''head -1 | sed -re "$skipRedirectSF"'';
  versionExtractorSedScript = ''$extractReleaseSF'';
  versionReferenceCreator = ''s@$version@\''${version}@g'';
  baseName = "webdruid";
}
