{ stdenv
, fetchFromGitHub
, fetchpatch
, bison
, pkgconfig
, gettext
, desktop-file-utils
, glib
, gtk2
, libxml2
, libbfd
, zlib
, binutils
, gnutls
, enableGui ? true
}:

stdenv.mkDerivation rec {
  pname = "gtk-gnutella";
  # NOTE: Please remove hardeningDisable on the next release, see:
  # https://sourceforge.net/p/gtk-gnutella/bugs/555/#5c19
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "gtk-gnutella";
    repo = "gtk-gnutella";
    rev = "v${version}";
    sha256 = "0j596dpajk68bkry0gmpqawsi61rphfciy4vji1dh890jyhkhdgy";
  };

  nativeBuildInputs = [
    bison
    desktop-file-utils
    gettext
    pkgconfig
  ];
  buildInputs = [
    glib
    gnutls
    libbfd
    libxml2
    zlib
  ]
  ++
    stdenv.lib.optionals (enableGui) [ gtk2 ]
  ;

  configureScript = "./build.sh";
  configureFlags = [
    "--configure-only"
    # See https://sourceforge.net/p/gtk-gnutella/bugs/555/
    "--disable-malloc"
  ]
    ++ stdenv.lib.optionals (!enableGui) [ "--topless" ]
  ;

  hardeningDisable = [ "bindnow" "fortify" "pic" "relro" ];

  enableParallelBuilding = true;

  postInstall = ''
    install -Dm0444 src/${pname}.man $out/share/man/man1/${pname}.1
  '';

  meta = with stdenv.lib; {
    description = "A GTK Gnutella client, optimized for speed and scalability";
    homepage = "http://gtk-gnutella.sourceforge.net/"; # Code: https://github.com/gtk-gnutella/gtk-gnutella
    changelog = "https://raw.githubusercontent.com/gtk-gnutella/gtk-gnutella/v${version}/ChangeLog";
    maintainers = [ maintainers.doronbehar ];
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
  };
}
