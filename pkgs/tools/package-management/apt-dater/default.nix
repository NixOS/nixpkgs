{ stdenv, fetchurl
, automake115x, autoconf, pkgconfig, gettext
, vim, glib, libxml2, openssl, ncurses, popt, screen
}:

stdenv.mkDerivation rec {
  name = "apt-dater-${version}";
  version = "1.0.3";

  src = fetchurl {
    url = "https://github.com/DE-IBH/apt-dater/archive/v${version}.tar.gz";
    sha256 = "891b15e4dd37c7b35540811bbe444e5f2a8d79b1c04644730b99069eabf1e10f";
  };

  nativeBuildInputs = [
    pkgconfig automake115x autoconf gettext
  ];

  buildInputs = [
    libxml2 ncurses vim glib popt screen
  ];

  configureFlags = [ "--disable-history" ];

  prePatch = ''
    substituteInPlace etc/Makefile.am \
      --replace 02770 0770
  '';

  postPatch = ''
    substituteInPlace configure.ac \
      --replace "/usr/bin/screen" "${screen}/bin/screen"
  '';

  doCheck = true;

  meta = with stdenv.lib; {
    homepage = https://github.com/DE-IBH/apt-dater;
    description = "Terminal-based remote package update manager";
    longDescription = ''
      Provides an ncurses frontend for managing package updates on a large
      number of remote hosts using SSH. It supports Debian-based managed hosts
      as well as rug (e.g. openSUSE) and yum (e.g. CentOS) based systems.
    '';
    license = licenses.gpl2;
    maintainers = with maintainers; [ enko ];
  };
}
