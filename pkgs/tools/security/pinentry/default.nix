{ fetchurl, fetchpatch, stdenv, lib, pkgconfig
, libgpgerror, libassuan
, ncurses, gtk2, qt
, libcap ? null, libsecret ? null, gcr ? null
, flavours ? [ "curses" "tty" "gtk2" "qt" "gnome3" "emacs" ]
}:

with stdenv.lib;

assert isList flavours && flavours != [];

let
  mkFlag = pfxTrue: pfxFalse: cond: name:
    "--${if cond then pfxTrue else pfxFalse}-${name}";
  mkEnable = mkFlag "enable" "disable";
  mkWith = mkFlag "with" "without";

  mkEnablePinentry = f:
    let
      info = flavourInfo.${f};
      inputs = info.buildInputs or [];
      flag = flavourInfo.${f}.flag or null;
      inputsSatifsfied = inputs == [] || all (f: !(isNull f)) inputs;
    in
      optionalString (flag != null)
        (mkEnable (elem f flavours && inputsSatifsfied) ("pinentry-" + flag));

  flavourInfo = {
    curses = { bin = "curses"; buildInputs = [ ncurses ]; };
    tty = { bin = "tty"; flag = "tty"; };
    gtk2 = { bin = "gtk-2"; flag = "gtk2"; buildInputs = [ gtk2 ]; };
    gnome3 = { bin = "gnome3"; flag = "gnome3"; buildInputs = [ gcr ]; };
    qt = { bin = "qt"; flag = "qt"; buildInputs = [ qt ]; };
    emacs = { bin = "emacs"; flag = "emacs"; buildInputs = []; };
  };

in

stdenv.mkDerivation rec {
  name = "pinentry-1.1.0";

  src = fetchurl {
    url = "mirror://gnupg/pinentry/${name}.tar.bz2";
    sha256 = "0w35ypl960pczg5kp6km3dyr000m1hf0vpwwlh72jjkjza36c1v8";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libgpgerror libassuan libcap libsecret ]
    ++ flatten (flip map flavours (f: flavourInfo.${f}.buildInputs or []));

  patches = optionals (elem "gtk2" flavours) [
    (fetchpatch {
      url = https://sources.debian.org/data/main/p/pinentry/1.1.0-1/debian/patches/0007-gtk2-When-X11-input-grabbing-fails-try-again-over-0..patch;
      sha256 = "15r1axby3fdlzz9wg5zx7miv7gqx2jy4immaw4xmmw5skiifnhfd";
    })
  ];

  configureFlags = [
    (mkWith   (libcap != null)    "libcap")
    (mkEnable (libsecret != null) "libsecret")
  ] ++ (map mkEnablePinentry (attrNames flavourInfo));

  postInstall =
    concatStrings (flip map flavours (f:
      let
        binary = "pinentry-" + flavourInfo.${f}.bin;
        outputVar = "$" + f;
      in ''
        moveToOutput bin/${binary} ${outputVar}
        ln -sf ${outputVar}/bin/${binary} ${outputVar}/bin/pinentry
      ''))
    + ''
      ln -sf ${head flavours}/bin/pinentry-${flavourInfo.${head flavours}.bin} $out/bin/pinentry
    '';

  outputs = [ "out" ] ++ flavours;

  passthru = { inherit flavours; };

  meta = with stdenv.lib; {
    homepage = http://gnupg.org/aegypten2/;
    description = "GnuPG’s interface to passphrase input";
    license = licenses.gpl2Plus;
    platforms = platforms.all;
    longDescription = ''
      Pinentry provides a console and (optional) GTK+ and Qt GUIs allowing users
      to enter a passphrase when `gpg' or `gpg2' is run and needs it.
    '';
    maintainers = with maintainers; [ ttuegel fpletz ];
  };
}
