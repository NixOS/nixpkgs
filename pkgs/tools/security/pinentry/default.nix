{
  stdenv,
  lib,
  fetchurl,
  fetchpatch,
  pkg-config,
  autoreconfHook,
  wrapGAppsHook3,
  kdePackages,
  libgpg-error,
  libassuan,
  libsForQt5,
  qt6,
  ncurses,
  gtk2,
  gcr,
  withLibsecret ? true,
  libsecret,
}:

let
  flavorInfo = {
    tty = {
      flag = "tty";
    };
    curses = {
      flag = "curses";
      buildInputs = [ ncurses ];
    };
    gtk2 = {
      flag = "gtk2";
      buildInputs = [ gtk2 ];
    };
    gnome3 = {
      flag = "gnome3";
      buildInputs = [ gcr ];
      nativeBuildInputs = [ wrapGAppsHook3 ];
    };
    qt5 = {
      flag = "qt5";
      buildInputs = [
        libsForQt5.qtbase
        libsForQt5.kwayland
        libsForQt5.qtx11extras
      ];
      nativeBuildInputs = [ libsForQt5.wrapQtAppsHook ];
    };
    qt = {
      flag = "qt";
      buildInputs = [
        qt6.qtbase
        qt6.qtwayland
        kdePackages.kguiaddons
      ];
      nativeBuildInputs = [ qt6.wrapQtAppsHook ];
    };
    emacs = {
      flag = "emacs";
    };
  };

  buildPinentry =
    pinentryExtraPname: buildFlavors:
    let
      enableFeaturePinentry =
        f: lib.enableFeature (lib.elem f buildFlavors) ("pinentry-" + flavorInfo.${f}.flag);
    in
    stdenv.mkDerivation rec {
      pname = "pinentry-${pinentryExtraPname}";
      version = "1.3.2";

      src = fetchurl {
        url = "mirror://gnupg/pinentry/pinentry-${version}.tar.bz2";
        hash = "sha256-jphu2IVhtNpunv4MVPpMqJIwNcmSZN8LBGRJfF+5Tp4=";
      };

      nativeBuildInputs = [
        pkg-config
        autoreconfHook
      ]
      ++ lib.concatMap (f: flavorInfo.${f}.nativeBuildInputs or [ ]) buildFlavors;

      buildInputs = [
        libgpg-error
        libassuan
      ]
      ++ lib.optional withLibsecret libsecret
      ++ lib.concatMap (f: flavorInfo.${f}.buildInputs or [ ]) buildFlavors;

      dontWrapGApps = true;
      dontWrapQtApps = true;

      patches = [
        ./autoconf-ar.patch
        ./gettext-0.25.patch
      ]
      ++ lib.optionals (lib.elem "gtk2" buildFlavors) [
        (fetchpatch {
          url = "https://salsa.debian.org/debian/pinentry/raw/debian/1.1.0-1/debian/patches/0007-gtk2-When-X11-input-grabbing-fails-try-again-over-0..patch";
          sha256 = "15r1axby3fdlzz9wg5zx7miv7gqx2jy4immaw4xmmw5skiifnhfd";
        })
      ];

      configureFlags = [
        "--with-libgpg-error-prefix=${libgpg-error.dev}"
        "--with-libassuan-prefix=${libassuan.dev}"
        (lib.enableFeature withLibsecret "libsecret")
      ]
      ++ (map enableFeaturePinentry (lib.attrNames flavorInfo));

      postInstall =
        lib.optionalString (lib.elem "gnome3" buildFlavors) ''
          wrapGApp $out/bin/pinentry-gnome3
        ''
        + lib.optionalString (lib.elem "qt5" buildFlavors) ''
          wrapQtApp $out/bin/pinentry-qt5
          ln -sf $out/bin/pinentry-qt5 $out/bin/pinentry-qt
        ''
        + lib.optionalString (lib.elem "qt" buildFlavors) ''
          wrapQtApp $out/bin/pinentry-qt
        '';

      passthru = {
        flavors = buildFlavors;
      };

      meta = {
        homepage = "https://gnupg.org/software/pinentry/index.html";
        description = "GnuPG’s interface to passphrase input";
        license = lib.licenses.gpl2Plus;
        platforms =
          if lib.elem "gnome3" buildFlavors then
            lib.platforms.linux
          else if (lib.elem "qt5" buildFlavors || lib.elem "qt" buildFlavors) then
            (lib.remove "aarch64-darwin" lib.platforms.all)
          else
            lib.platforms.all;
        longDescription = ''
          Pinentry provides a console and (optional) GTK and Qt GUIs allowing users
          to enter a passphrase when `gpg` or `gpg2` is run and needs it.
        '';
        maintainers = with lib.maintainers; [ fpletz ];
        mainProgram = "pinentry";
      };
    };
in
{
  pinentry-curses = buildPinentry "curses" [
    "curses"
    "tty"
  ];
  pinentry-emacs = buildPinentry "emacs" [
    "emacs"
    "curses"
    "tty"
  ];
  pinentry-gnome3 = buildPinentry "gnome3" [
    "gnome3"
    "curses"
    "tty"
  ];
  pinentry-gtk2 = buildPinentry "gtk2" [
    "gtk2"
    "curses"
    "tty"
  ];
  pinentry-qt5 = buildPinentry "qt5" [
    "qt5"
    "curses"
    "tty"
  ];
  pinentry-qt = buildPinentry "qt" [
    "qt"
    "curses"
    "tty"
  ];
  pinentry-tty = buildPinentry "tty" [ "tty" ];
  pinentry-all = buildPinentry "all" [
    "curses"
    "tty"
    "gtk2"
    "gnome3"
    "qt"
    "emacs"
  ];
}
