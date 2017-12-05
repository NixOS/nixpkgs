{ stdenv, fetchurl, python3Packages, php }:

python3Packages.buildPythonApplication rec {
  name = "nextcloud-news-updater-${version}";
  version = "9.0.2";

  src = fetchurl {
    url = "mirror://pypi/n/nextcloud_news_updater/nextcloud_news_updater-${version}.tar.gz";
    sha256 = "1m6g4591zyvjl2fji4iwl9api02racgc9rqa0gf0mfsqwdr77alw";
  };

  doCheck = false;

  propagatedBuildInputs = [ php ];

  meta = {
    description = "Fast parallel feed updater for the Nextcloud news app";
    homepage = https://github.com/nextcloud/news-updater;
    license = stdenv.lib.licenses.gpl3;
    maintainers = with stdenv.lib.maintainers; [ schneefux ];
  };
}
