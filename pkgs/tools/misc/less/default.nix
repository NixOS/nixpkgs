{ lib
, stdenv
, fetchurl
, fetchpatch
, ncurses
, pcre2
}:

stdenv.mkDerivation rec {
  pname = "less";
  version = "608";

  # Only tarballs on the website are valid releases,
  # other versions, e.g. git tags are considered snapshots.
  src = fetchurl {
    url = "https://www.greenwoodsoftware.com/less/less-${version}.tar.gz";
    hash = "sha256-ppq+LgoSZ3fgIdO3OqMiLhsmHxDmRiTUHsB5aFpqwgk=";
  };

  patches = [
    (fetchpatch {
      # https://github.com/advisories/GHSA-5xw7-xf7p-gm82
      name = "CVE-2022-46663.patch";
      url = "https://github.com/gwsw/less/commit/a78e1351113cef564d790a730d657a321624d79c.patch";
      hash = "sha256-gWgCzoMt1WyVJVKYzkMq8HfaTlU1XUtC8fvNFUQT0sI=";
    })
  ];

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
