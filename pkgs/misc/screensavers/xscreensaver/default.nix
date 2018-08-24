{ stdenv, fetchurl, pkgconfig, bc, perl, pam, libXext, libXScrnSaver, libX11
, libXrandr, libXmu, libXxf86vm, libXrender, libXxf86misc, libjpeg, libGLU_combined, gtk2
, libxml2, libglade, intltool, xorg, makeWrapper, gle
, forceInstallAllHacks ? false
}:

stdenv.mkDerivation rec {
  version = "5.40";
  name = "xscreensaver-${version}";

  src = fetchurl {
    url = "https://www.jwz.org/xscreensaver/${name}.tar.gz";
    sha256 = "1q2sr7h6ps6d3hk8895g12rrcqiihjl7py1ly077ikv4866r181h";
  };

  buildInputs =
    [ pkgconfig bc perl libjpeg libGLU_combined gtk2 libxml2 libglade pam
      libXext libXScrnSaver libX11 libXrandr libXmu libXxf86vm libXrender
      libXxf86misc intltool xorg.appres makeWrapper gle
    ];

  preConfigure =
    ''
      # Fix installation paths for GTK resources.
      sed -e 's%@GTK_DATADIR@%@datadir@% ; s%@PO_DATADIR@%@datadir@%' \
          -i driver/Makefile.in po/Makefile.in.in
    '';

  configureFlags =
    [ "--with-gl" "--with-pam" "--with-pixbuf" "--with-proc-interrupts"
      "--with-dpms-ext" "--with-randr-ext" "--with-xinerama-ext"
      "--with-xf86vmode-ext" "--with-xf86gamma-ext" "--with-randr-ext"
      "--with-xshm-ext" "--with-xdbe-ext"
      "--with-x-app-defaults=\${out}/share/xscreensaver/app-defaults"
    ];

  postInstall = ''
      wrapProgram $out/bin/xscreensaver-text \
        --prefix PATH : ${stdenv.lib.makeBinPath [xorg.appres]}
  ''
  + stdenv.lib.optionalString forceInstallAllHacks ''
    make -C hacks/glx dnalogo
    cat hacks/Makefile.in | grep -E '([a-z0-9]+):[[:space:]]*\1[.]o' | cut -d : -f 1  | xargs make -C hacks
    cat hacks/glx/Makefile.in | grep -E '([a-z0-9]+):[[:space:]]*\1[.]o' | cut -d : -f 1  | xargs make -C hacks/glx
    cp -f $(find hacks -type f -perm -111 "!" -name "*.*" )  "$out/libexec/xscreensaver"
  ''
  ;

  meta = {
    homepage = https://www.jwz.org/xscreensaver/;
    description = "A set of screensavers";
    maintainers = with stdenv.lib.maintainers; [ raskin ];
    platforms = stdenv.lib.platforms.unix; # Once had cygwin problems
    inherit version;
    downloadPage = "https://www.jwz.org/xscreensaver/download.html";
    updateWalker = true;
  };
}
