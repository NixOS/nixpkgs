{fetchzip}: {
  plugins.civicrm = fetchzip rec {
    name = "civicrm";
    version = "5.56.0";
    url = "https://storage.googleapis.com/${name}/${name}-stable/${version}/${name}-${version}-wordpress.zip";
    hash = "sha256-XsNFxVL0LF+OHlsqjjTV41x9ERLwMDq9BnKKP3Px2aI=";
  };
}
