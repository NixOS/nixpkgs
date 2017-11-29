{ stdenv, automake115x, autoconf, vim, glib, clang, libxml2, fetchurl, openssl, ncurses, pkgconfig, popt, screen, gettext }:

stdenv.mkDerivation rec {
  name = "apt-dater-${version}";
  version = "1.0.3";

  src = fetchurl {
    url = "https://github.com/DE-IBH/apt-dater/archive/v${version}.tar.gz";
    sha256 = "891b15e4dd37c7b35540811bbe444e5f2a8d79b1c04644730b99069eabf1e10f";
  };

  buildInputs = [ clang libxml2 pkgconfig ncurses automake115x autoconf vim glib popt screen gettext ];

  configureFlags = [ "--disable-history" ];

  prePatch = ''
    substituteInPlace etc/Makefile.am --replace 02770 0770
  '';

  postPatch = ''
    substituteInPlace configure.ac --replace "/usr/bin/screen" "${screen}/bin/screen"
  '';

  doCheck = true;

  meta = with stdenv.lib; {
    homepage = https://github.com/DE-IBH/apt-dater;
    description = "terminal-based remote package update manager";
    longDescription = "apt-dater provides an ncurses frontend for managing package updates on a large number of remote hosts using SSH. It supports Debian-based managed hosts as well as rug (e.g. openSUSE) and yum (e.g. CentOS) based systems.";
    license = licenses.gpl2;
    maintainers = with maintainers; [ enko ];
  };
}
