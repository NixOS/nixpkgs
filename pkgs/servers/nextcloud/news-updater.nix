{
  lib,
  fetchurl,
  python3Packages,
  php,
}:

python3Packages.buildPythonApplication rec {
  pname = "nextcloud-news-updater";
  version = "11.0.0";

  src = fetchurl {
    url = "mirror://pypi/n/nextcloud_news_updater/nextcloud_news_updater-${version}.tar.gz";
    sha256 = "bc2055c16f0dbf610b7e17650508a18fa5a1de652ecdf69c5d4073c97376e9cf";
  };

  doCheck = false;

  propagatedBuildInputs = [ php ];

  meta = {
    description = "Fast parallel feed updater for the Nextcloud news app";
    mainProgram = "nextcloud-news-updater";
    homepage = "https://github.com/nextcloud/news-updater";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ schneefux ];
  };
}
