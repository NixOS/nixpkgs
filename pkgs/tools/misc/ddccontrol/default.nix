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
  version = "0.6.3";

  src = fetchFromGitHub {
    owner = "ddccontrol";
    repo = "ddccontrol";
    rev = version;
    sha256 = "sha256-0mvkIW0Xsi7co/INmlNeTclBxGoqoJliFanA/RFMaLM=";
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
