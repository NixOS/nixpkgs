{ fetchurl, mkDerivation, fetchpatch, stdenv, lib, pkg-config, autoreconfHook, wrapGAppsHook
, libgpg-error, libassuan, qtbase, wrapQtAppsHook
, ncurses, gtk2, gcr
, withLibsecret ? true, libsecret
, enabledFlavors ? [ "curses" "tty" "gtk2" "emacs" ]
  ++ lib.optionals stdenv.isLinux [ "gnome3" ]
  ++ lib.optionals (!stdenv.isDarwin) [ "qt" ]
}:

assert lib.isList enabledFlavors && enabledFlavors != [];

let
  pinentryMkDerivation =
    if (builtins.elem "qt" enabledFlavors)
      then mkDerivation
      else stdenv.mkDerivation;

  enableFeaturePinentry = f:
    let
      flag = flavorInfo.${f}.flag or null;
    in
      lib.optionalString (flag != null)
        (lib.enableFeature (lib.elem f enabledFlavors) ("pinentry-" + flag));

  flavorInfo = {
    curses = { bin = "curses"; flag = "curses"; buildInputs = [ ncurses ]; };
    tty = { bin = "tty"; flag = "tty"; };
    gtk2 = { bin = "gtk-2"; flag = "gtk2"; buildInputs = [ gtk2 ]; };
    gnome3 = { bin = "gnome3"; flag = "gnome3"; buildInputs = [ gcr ]; nativeBuildInputs = [ wrapGAppsHook ]; };
    qt = { bin = "qt"; flag = "qt"; buildInputs = [ qtbase ]; nativeBuildInputs = [ wrapQtAppsHook ]; };
    emacs = { bin = "emacs"; flag = "emacs"; buildInputs = []; };
  };

in

pinentryMkDerivation rec {
  pname = "pinentry";
  version = "1.2.1";

  src = fetchurl {
    url = "mirror://gnupg/pinentry/${pname}-${version}.tar.bz2";
    sha256 = "sha256-RXoYXlqFI4+5RalV3GNSq5YtyLSHILYvyfpIx1QKQGc=";
  };

  nativeBuildInputs = [ pkg-config autoreconfHook ]
    ++ lib.concatMap(f: flavorInfo.${f}.nativeBuildInputs or []) enabledFlavors;

  buildInputs = [ libgpg-error libassuan ]
    ++ lib.optional withLibsecret libsecret
    ++ lib.concatMap(f: flavorInfo.${f}.buildInputs or []) enabledFlavors;

  dontWrapGApps = true;
  dontWrapQtApps = true;

  patches = [
    ./autoconf-ar.patch
  ] ++ lib.optionals (lib.elem "gtk2" enabledFlavors) [
    (fetchpatch {
      url = "https://salsa.debian.org/debian/pinentry/raw/debian/1.1.0-1/debian/patches/0007-gtk2-When-X11-input-grabbing-fails-try-again-over-0..patch";
      sha256 = "15r1axby3fdlzz9wg5zx7miv7gqx2jy4immaw4xmmw5skiifnhfd";
    })
  ];

  configureFlags = [
    "--with-libgpg-error-prefix=${libgpg-error.dev}"
    "--with-libassuan-prefix=${libassuan.dev}"
    (lib.enableFeature withLibsecret "libsecret")
  ] ++ (map enableFeaturePinentry (lib.attrNames flavorInfo));

  postInstall =
    lib.concatStrings (lib.flip map enabledFlavors (f:
      let
        binary = "pinentry-" + flavorInfo.${f}.bin;
      in ''
        moveToOutput bin/${binary} ${placeholder f}
        ln -sf ${placeholder f}/bin/${binary} ${placeholder f}/bin/pinentry
      '' + lib.optionalString (f == "gnome3") ''
        wrapGApp ${placeholder f}/bin/${binary}
      '' + lib.optionalString (f == "qt") ''
        wrapQtApp ${placeholder f}/bin/${binary}
      '')) + ''
      ln -sf ${placeholder (lib.head enabledFlavors)}/bin/pinentry-${flavorInfo.${lib.head enabledFlavors}.bin} $out/bin/pinentry
    '';

  outputs = [ "out" ] ++ enabledFlavors;

  passthru = { flavors = enabledFlavors; };

  meta = with lib; {
    homepage = "http://gnupg.org/aegypten2/";
    description = "GnuPG’s interface to passphrase input";
    license = licenses.gpl2Plus;
    platforms = platforms.all;
    longDescription = ''
      Pinentry provides a console and (optional) GTK and Qt GUIs allowing users
      to enter a passphrase when `gpg' or `gpg2' is run and needs it.
    '';
    maintainers = with maintainers; [ ttuegel fpletz ];
  };
}
