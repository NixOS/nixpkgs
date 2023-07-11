{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, intltool
, libxml2
, pciutils
, pkg-config
, gtk2
, ddccontrol-db
}:

stdenv.mkDerivation rec {
  pname = "ddccontrol";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "ddccontrol";
    repo = "ddccontrol";
    rev = version;
    sha256 = "sha256-En2e0FDKLpMjuxa2aXuvI6h7d+D1D5x1dDg96924/qM=";
  };

  nativeBuildInputs = [
    autoreconfHook
    intltool
    pkg-config
  ];

  buildInputs = [
    libxml2
    pciutils
    gtk2
    ddccontrol-db
  ];

  configureFlags = [
    "--with-systemdsystemunitdir=${placeholder "out"}/etc/systemd/system"
  ];

  prePatch = ''
    substituteInPlace configure.ac              \
      --replace                                 \
      "\$""{datadir}/ddccontrol-db"             \
      "${ddccontrol-db}/share/ddccontrol-db"

    substituteInPlace src/ddcpci/Makefile.am    \
       --replace "chmod 4711" "chmod 0711"
  '' + lib.optionalString (lib.versionAtLeast "0.6.1" version) ''
    # Upstream PR: https://github.com/ddccontrol/ddccontrol/pull/115
    substituteInPlace src/lib/Makefile.am       \
      --replace "/etc/" "\$""{sysconfdir}/"
  '';

  preConfigure = ''
    intltoolize --force
  '';

  meta = with lib; {
    description = "A program used to control monitor parameters by software";
    homepage = "https://github.com/ddccontrol/ddccontrol";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with lib.maintainers; [ pakhfn ];
  };
}
