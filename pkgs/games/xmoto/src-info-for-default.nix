{
  downloadPage = "http://xmoto.tuxfamily.org/";
  baseName = "xmoto";
  sourceRegexp = "xmoto-.*-src[.]tar[.].*";
  versionExtractorSedScript = ''$dashDelimitedVersion'';
  versionReferenceCreator=''$(replaceAllVersionOccurences)'';
}
