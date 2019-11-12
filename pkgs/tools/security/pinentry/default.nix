{ fetchurl, mkDerivation, fetchpatch, stdenv, lib, pkgconfig, autoreconfHook, wrapGAppsHook
, libgpgerror, libassuan, qtbase, wrapQtAppsHook
, ncurses, gtk2, gcr
, libcap ? null, libsecret ? null
, enabledFlavors ? [ "curses" "tty" "gtk2" "qt" "gnome3" "emacs" ]
}:

with stdenv.lib;

assert isList enabledFlavors && enabledFlavors != [];

let
  pinentryMkDerivation =
    if (builtins.elem "qt" enabledFlavors)
      then mkDerivation
      else stdenv.mkDerivation;

  mkFlag = pfxTrue: pfxFalse: cond: name:
    "--${if cond then pfxTrue else pfxFalse}-${name}";
  mkEnable = mkFlag "enable" "disable";
  mkWith = mkFlag "with" "without";

  mkEnablePinentry = f:
    let
      info = flavorInfo.${f};
      flag = flavorInfo.${f}.flag or null;
    in
      optionalString (flag != null)
        (mkEnable (elem f enabledFlavors) ("pinentry-" + flag));

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
  version = "1.1.0";

  src = fetchurl {
    url = "mirror://gnupg/pinentry/${pname}-${version}.tar.bz2";
    sha256 = "0w35ypl960pczg5kp6km3dyr000m1hf0vpwwlh72jjkjza36c1v8";
  };

  nativeBuildInputs = [ pkgconfig autoreconfHook ]
    ++ concatMap(f: flavorInfo.${f}.nativeBuildInputs or []) enabledFlavors;
  buildInputs = [ libgpgerror libassuan libcap libsecret ]
    ++ concatMap(f: flavorInfo.${f}.buildInputs or []) enabledFlavors;

  dontWrapGApps = true;
  dontWrapQtApps = true;

  patches = [
    ./autoconf-ar.patch
  ] ++ optionals (elem "gtk2" enabledFlavors) [
    (fetchpatch {
      url = "https://salsa.debian.org/debian/pinentry/raw/debian/1.1.0-1/debian/patches/0007-gtk2-When-X11-input-grabbing-fails-try-again-over-0..patch";
      sha256 = "15r1axby3fdlzz9wg5zx7miv7gqx2jy4immaw4xmmw5skiifnhfd";
    })
  ];

  configureFlags = [
    (mkWith   (libcap != null)    "libcap")
    (mkEnable (libsecret != null) "libsecret")
  ] ++ (map mkEnablePinentry (attrNames flavorInfo));

  postInstall =
    concatStrings (flip map enabledFlavors (f:
      let
        binary = "pinentry-" + flavorInfo.${f}.bin;
      in ''
        moveToOutput bin/${binary} ${placeholder f}
        ln -sf ${placeholder f}/bin/${binary} ${placeholder f}/bin/pinentry
      '' + optionalString (f == "gnome3") ''
        wrapGApp ${placeholder f}/bin/${binary}
      '' + optionalString (f == "qt") ''
        wrapQtApp ${placeholder f}/bin/${binary}
      '')) + ''
      ln -sf ${placeholder (head enabledFlavors)}/bin/pinentry-${flavorInfo.${head enabledFlavors}.bin} $out/bin/pinentry
    '';

  outputs = [ "out" ] ++ enabledFlavors;

  passthru = { flavors = enabledFlavors; };

  meta = with stdenv.lib; {
    homepage = http://gnupg.org/aegypten2/;
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
