{
  downloadPage = "http://sourceforge.net/projects/linuxwacom/files/";
  baseName = "linuxwacom";
  choiceCommand = ''head -1 | sed -re "$skipRedirectSF"'';
  versionExtractorSedScript = "\$extractReleaseSF";
  versionReferenceCreator = "\$(replaceAllVersionOccurences)";
}
