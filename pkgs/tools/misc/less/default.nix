{ lib, stdenv, fetchurl, fetchpatch, ncurses, lessSecure ? false }:

stdenv.mkDerivation rec {
  pname = "less";
  version = "608";

  src = fetchurl {
    url = "https://www.greenwoodsoftware.com/less/less-${version}.tar.gz";
    sha256 = "02f2d9d6hyf03va28ip620gjc6rf4aikmdyk47h7frqj18pbx6m6";
  };

  patches = [
    (fetchpatch {
      # https://github.com/advisories/GHSA-5xw7-xf7p-gm82
      name = "CVE-2022-46663.patch";
      url = "https://github.com/gwsw/less/commit/a78e1351113cef564d790a730d657a321624d79c.patch";
      hash = "sha256-gWgCzoMt1WyVJVKYzkMq8HfaTlU1XUtC8fvNFUQT0sI=";
    })
  ];

  configureFlags = [ "--sysconfdir=/etc" ] # Look for ‘sysless’ in /etc.
    ++ lib.optionals lessSecure [ "--with-secure" ];

  buildInputs = [ ncurses ];

  meta = with lib; {
    homepage = "https://www.greenwoodsoftware.com/less/";
    description = "A more advanced file pager than ‘more’";
    platforms = platforms.unix;
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ eelco dtzWill ];
  };
}
