{
  lib,
  buildPythonPackage,
  click-plugins,
  colorama,
  fetchPypi,
  requests,
  setuptools,
  tldextract,
  xlsxwriter,
}:

buildPythonPackage (finalAttrs: {
  pname = "shodan";
  version = "1.31.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    pname = "shodan";
    inherit (finalAttrs) version;
    hash = "sha256-xzJ1OG6gI5DhlsNcZgcGoo3U1TfFoh6zh6tiNvrCUfY=";
  };

  build-system = [ setuptools ];

  dependencies = [
    click-plugins
    colorama
    requests
    setuptools
    tldextract
    xlsxwriter
  ];

  # The tests require a shodan api key, so skip them.
  doCheck = false;

  pythonImportsCheck = [ "shodan" ];

  meta = {
    description = "Python library and command-line utility for Shodan";
    mainProgram = "shodan";
    homepage = "https://github.com/achillean/shodan-python";
    changelog = "https://github.com/achillean/shodan-python/blob/${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      fab
      lihop
    ];
  };
})
