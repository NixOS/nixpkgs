{ stdenv, fetchurl, python3Packages, php }:

python3Packages.buildPythonApplication rec {
  name = "nextcloud-news-updater-${version}";
  version = "10.0.0";

  src = fetchurl {
    url = "mirror://pypi/n/nextcloud_news_updater/nextcloud_news_updater-${version}.tar.gz";
    sha256 = "00pscz0p4s10y1ymb6sm0gx4a5wdbhimn30582x8i28n58nnl8j0";
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
