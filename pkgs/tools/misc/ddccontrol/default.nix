{ stdenv, fetchFromGitHub, autoreconfHook, intltool, libxml2
, pciutils, pkgconfig, gtk2, ddccontrol-db
, makeDesktopItem
}:

let version = "0.4.4"; in
stdenv.mkDerivation rec {
  pname = "ddccontrol";
  inherit version;

  src = fetchFromGitHub {
    owner = "ddccontrol";
    repo = "ddccontrol";
    rev = "0.4.4";
    sha256 = "09npy6z2j3jrvpvlr46vih31y2mbrh7wsqlbrjprxjv1j0kkz5q2";
  };

  nativeBuildInputs = [ autoreconfHook intltool pkgconfig ];

  buildInputs = [
    libxml2
    pciutils
    gtk2
    ddccontrol-db
  ];

  hardeningDisable = [ "format" "bindnow" ];

  prePatch = ''
    oldPath="\$""{datadir}/ddccontrol-db"
    newPath="${ddccontrol-db}/share/ddccontrol-db"
    sed -i -e "s|$oldPath|$newPath|" configure.ac
    sed -i -e "s/chmod 4711/chmod 0711/" src/ddcpci/Makefile*
  '';

  preConfigure = ''
    intltoolize --force
  '';

  postInstall = ''
    mkdir -p $out/share/applications/
    cp $desktopItem/share/applications/* $out/share/applications/
    for entry in $out/share/applications/*.desktop; do
      substituteAllInPlace $entry
    done
  '';

  desktopItem = makeDesktopItem {
    name = "gddccontrol";
    desktopName = "gddccontrol";
    genericName = "DDC/CI control";
    comment = meta.description;
    exec = "@out@/bin/gddccontrol";
    icon = "gddccontrol";
    categories = "Settings;HardwareSettings;";
  };

  meta = with stdenv.lib; {
    description = "A program used to control monitor parameters by software";
    homepage = https://github.com/ddccontrol/ddccontrol;
    license = licenses.gpl2;
    platforms = [ "i686-linux" "x86_64-linux" ];
    maintainers = [ stdenv.lib.maintainers.pakhfn ];
  };
}
