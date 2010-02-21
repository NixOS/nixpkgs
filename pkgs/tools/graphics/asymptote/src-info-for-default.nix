{
  downloadPage = "http://sourceforge.net/projects/asymptote/files/";
  baseName = "asymptote";
  sourceRegexp = ".*[.]src[.]tgz";
  versionExtractorSedScript = ''$extractReleaseSF'';
  versionReferenceCreator = ''$(replaceAllVersionOccurences)'';
  choiceCommand = ''head -1 | sed -re "$skipRedirectSF"'';
}
