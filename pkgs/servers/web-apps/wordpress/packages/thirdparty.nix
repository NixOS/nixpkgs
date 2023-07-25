{fetchzip}: {
  plugins.civicrm = fetchzip rec {
    name = "civicrm";
    version = "5.56.0";
    url = "https://storage.googleapis.com/${name}/${name}-stable/${version}/${name}-${version}-wordpress.zip";
    hash = "sha256-XsNFxVL0LF+OHlsqjjTV41x9ERLwMDq9BnKKP3Px2aI=";
  };
  themes.geist = fetchzip rec {
    name = "geist";
    version = "2.0.3";
    url = "https://github.com/christophery/geist/archive/refs/tags/${version}.zip";
    hash = "sha256-c85oRhqu5E5IJlpgqKJRQITur1W7x40obOvHZbPevzU=";
  };
}
