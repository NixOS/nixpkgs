{ lib
, stdenv
, fetchurl
, ncurses
, pcre2
}:

stdenv.mkDerivation rec {
  pname = "less";
  version = "633";

  # Only tarballs on the website are valid releases,
  # other versions, e.g. git tags are considered snapshots.
  src = fetchurl {
    url = "https://www.greenwoodsoftware.com/less/less-${version}.tar.gz";
    hash = "sha256-LyAdZLgouIrzbf5s/bo+CBns4uRG6+YiSBMgmq7+0E8=";
  };

  configureFlags = [
    # Look for ‘sysless’ in /etc.
    "--sysconfdir=/etc"
    "--with-regex=pcre2"
  ];

  buildInputs = [
    ncurses
    pcre2
  ];

  meta = with lib; {
    homepage = "https://www.greenwoodsoftware.com/less/";
    description = "A more advanced file pager than ‘more’";
    platforms = platforms.unix;
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ eelco dtzWill ];
  };
}
