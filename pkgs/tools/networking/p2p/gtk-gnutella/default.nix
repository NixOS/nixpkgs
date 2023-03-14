{ lib, stdenv
, fetchFromGitHub
, fetchpatch
, bison
, pkg-config
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
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "gtk-gnutella";
    repo = "gtk-gnutella";
    rev = "v${version}";
    sha256 = "sha256-LbSUdU+a9G8qL7gCZVJQ6UQMATpOMtktY6FeOkUuaYI=";
  };

  nativeBuildInputs = [
    bison
    desktop-file-utils
    gettext
    pkg-config
  ];
  buildInputs = [
    glib
    gnutls
    libbfd
    libxml2
    zlib
  ]
  ++
    lib.optionals (enableGui) [ gtk2 ]
  ;

  configureScript = "./build.sh";
  configureFlags = [
    "--configure-only"
    # See https://sourceforge.net/p/gtk-gnutella/bugs/555/
    "--disable-malloc"
  ]
    ++ lib.optionals (!enableGui) [ "--topless" ]
  ;

  enableParallelBuilding = true;

  postInstall = ''
    install -Dm0444 src/${pname}.man $out/share/man/man1/${pname}.1
  '';

  meta = with lib; {
    description = "A GTK Gnutella client, optimized for speed and scalability";
    homepage = "https://gtk-gnutella.sourceforge.net/"; # Code: https://github.com/gtk-gnutella/gtk-gnutella
    changelog = "https://raw.githubusercontent.com/gtk-gnutella/gtk-gnutella/v${version}/ChangeLog";
    maintainers = [ maintainers.doronbehar ];
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
  };
}
