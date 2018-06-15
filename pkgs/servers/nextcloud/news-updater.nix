{ stdenv, fetchurl, python3Packages, php }:

python3Packages.buildPythonApplication rec {
  name = "nextcloud-news-updater-${version}";
  version = "10.0.1";

  src = fetchurl {
    url = "mirror://pypi/n/nextcloud_news_updater/nextcloud_news_updater-${version}.tar.gz";
    sha256 = "14jj3w417wfsm1ki34d980b0s6vfn8i29g4c66qb2fizdq1d0z6q";
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
