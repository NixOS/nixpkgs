{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
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
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "ddccontrol";
    repo = "ddccontrol";
    rev = version;
    sha256 = "sha256-100SITpGbui/gRhFjVZxn6lZRB0najtGHd18oUpByJo=";
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

  patches = [
    # Upstream commit, fixed the version number in v1.0.0
    (fetchpatch {
      url = "https://github.com/ddccontrol/ddccontrol/commit/fc8c5b5d0f2b64b08b95f4a7d8f47f2fd8ceec34.patch";
      hash = "sha256-SB1BaolTNCUYgj38nMg1uLUqOHvnwCr8T3cnfu/7rjI=";
    })
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
