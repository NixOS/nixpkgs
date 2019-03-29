{ stdenv, fetchFromGitHub
, autoreconfHook, pkgconfig, gettext
, vim, glib, libxml2, openssl, ncurses, popt, screen
}:

stdenv.mkDerivation rec {
  name = "apt-dater-${version}";
  version = "1.0.4";

  src = fetchFromGitHub {
    owner = "DE-IBH";
    repo = "apt-dater";
    rev = "v${version}";
    sha256 = "1r6gz9jkh1wxi11mcq5p9mqg0szclsaq8ic79vnfnbjdrmmdfi4y";
  };

  nativeBuildInputs = [
    pkgconfig autoreconfHook gettext
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
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ c0bw3b ];
  };
}
