{ lib, fetchurl, python3Packages, php }:

python3Packages.buildPythonApplication rec {
  pname = "nextcloud-news-updater";
  version = "11.0.0";

  src = fetchurl {
    url = "mirror://pypi/n/nextcloud_news_updater/nextcloud_news_updater-${version}.tar.gz";
    hash = "sha256-vCBVwW8Nv2ELfhdlBQihj6Wh3mUuzfacXUBzyXN26c8=";
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
