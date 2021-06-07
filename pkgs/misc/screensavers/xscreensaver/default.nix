{ lib, stdenv, fetchurl
, pkg-config, intltool
, perl, gettext, libX11, libXext, libXi, libXt
, libXft, libXinerama, libXrandr, libXxf86vm, libGL, libGLU, gle
, gtk2, gdk-pixbuf, gdk-pixbuf-xlib, libxml2, pam
, systemd
, forceInstallAllHacks ? false
, withSystemd ? stdenv.isLinux
}:

stdenv.mkDerivation rec {
  version = "6.00";
  pname = "xscreensaver";

  src = fetchurl {
    url = "https://www.jwz.org/${pname}/${pname}-${version}.tar.gz";
    sha256 = "WFCIl0chuCjr1x/T67AZ0b8xITPJVurJZy1h9rSddwY=";
  };

  nativeBuildInputs = [
    pkg-config intltool
  ];

  buildInputs = [
    perl gettext libX11 libXext libXi libXt
    libXft libXinerama libXrandr libXxf86vm libGL libGLU gle
    gtk2 gdk-pixbuf gdk-pixbuf-xlib libxml2 pam
  ] ++ lib.optional withSystemd systemd;

  preConfigure = ''
    # Fix installation paths for GTK resources.
    sed -e 's%@GTK_DATADIR@%@datadir@% ; s%@PO_DATADIR@%@datadir@%' \
      -i driver/Makefile.in po/Makefile.in.in
  '';

  configureFlags = [
    "--with-app-defaults=${placeholder "out"}/share/xscreensaver/app-defaults"
  ];

  postInstall = lib.optionalString forceInstallAllHacks ''
    make -j$NIX_BUILD_CORES -C hacks/glx dnalogo
    cat hacks/Makefile.in \
      | grep -E '([a-z0-9]+):[[:space:]]*\1[.]o' | cut -d : -f 1 | xargs make -j$NIX_BUILD_CORES -C hacks
    cat hacks/glx/Makefile.in \
      | grep -E '([a-z0-9]+):[[:space:]]*\1[.]o' | cut -d : -f 1 | xargs make -j$NIX_BUILD_CORES -C hacks/glx
    cp -f $(find hacks -type f -perm -111 "!" -name "*.*" ) "$out/libexec/xscreensaver"
  '';

  meta = {
    homepage = "https://www.jwz.org/xscreensaver/";
    description = "A set of screensavers";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ raskin ];
    platforms = lib.platforms.unix; # Once had cygwin problems
    inherit version;
    downloadPage = "https://www.jwz.org/xscreensaver/download.html";
    updateWalker = true;
  };
}
