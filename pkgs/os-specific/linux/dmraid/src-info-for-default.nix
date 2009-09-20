{
  downloadPage = "http://people.redhat.com/~heinzm/sw/dmraid/src/old/?C=M;O=D";
  baseName = "dmraid";
  sourceRegexp = "^.*[.]tar[.]bz2\$";
  versionExtractorSedScript = ''s/.*-(.*)[.]tar[.]bz2/\1/'';
}
