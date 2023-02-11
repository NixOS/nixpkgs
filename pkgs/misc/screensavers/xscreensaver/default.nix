{ lib, stdenv, fetchurl, makeWrapper
, pkg-config, intltool
, perl, perlPackages, gettext, libX11, libXext, libXi, libXt
, libXft, libXinerama, libXrandr, libXxf86vm, libGL, libGLU, gle
, gtk2, gdk-pixbuf, gdk-pixbuf-xlib, libxml2, pam
, systemd, coreutils
, forceInstallAllHacks ? false
, withSystemd ? lib.meta.availableOn stdenv.hostPlatform systemd
}:

stdenv.mkDerivation rec {
  version = "6.04";
  pname = "xscreensaver";

  src = fetchurl {
    url = "https://www.jwz.org/${pname}/${pname}-${version}.tar.gz";
    sha256 = "sha256-eHAUsp8MV5Pswtk+EQmgSf9IqwwpuFHas09oPO72sVI=";
  };

  nativeBuildInputs = [
    pkg-config intltool makeWrapper
  ];

  buildInputs = [
    perl gettext libX11 libXext libXi libXt
    libXft libXinerama libXrandr libXxf86vm libGL libGLU gle
    gtk2 gdk-pixbuf gdk-pixbuf-xlib libxml2 pam
    perlPackages.LWPProtocolHttps perlPackages.MozillaCA
  ] ++ lib.optional withSystemd systemd;

  preConfigure = ''
    # Fix installation paths for GTK resources.
    sed -e 's%@GTK_DATADIR@%@datadir@% ; s%@PO_DATADIR@%@datadir@%' \
      -i driver/Makefile.in po/Makefile.in.in
  '';

  configureFlags = [
    "--with-app-defaults=${placeholder "out"}/share/xscreensaver/app-defaults"
  ];

  # "marbling" has NEON code that mixes signed and unsigned vector types
  NIX_CFLAGS_COMPILE = lib.optional stdenv.hostPlatform.isAarch "-flax-vector-conversions";

  postInstall = ''
    for bin in $out/bin/*; do
      wrapProgram "$bin" \
        --prefix PATH : "$out/libexec/xscreensaver" \
        --prefix PATH : "${lib.makeBinPath [ coreutils perl ]}" \
        --prefix PERL5LIB ':' $PERL5LIB
    done
  '' + lib.optionalString forceInstallAllHacks ''
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
    downloadPage = "https://www.jwz.org/xscreensaver/download.html";
  };
}
