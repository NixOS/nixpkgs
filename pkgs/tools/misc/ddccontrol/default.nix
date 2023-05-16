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
<<<<<<< HEAD
  version = "0.6.3";
=======
  version = "0.6.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "ddccontrol";
    repo = "ddccontrol";
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-0mvkIW0Xsi7co/INmlNeTclBxGoqoJliFanA/RFMaLM=";
=======
    sha256 = "sha256-En2e0FDKLpMjuxa2aXuvI6h7d+D1D5x1dDg96924/qM=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
=======
  '' + lib.optionalString (lib.versionAtLeast "0.6.1" version) ''
    # Upstream PR: https://github.com/ddccontrol/ddccontrol/pull/115
    substituteInPlace src/lib/Makefile.am       \
      --replace "/etc/" "\$""{sysconfdir}/"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
