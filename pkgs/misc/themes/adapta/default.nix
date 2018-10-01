{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, parallel, sassc, inkscape
, libxml2, glib, gdk_pixbuf, librsvg, gtk-engine-murrine, gnome3
, enableGnome ? true
, enableCinnamon ? true
, enableFlashback ? true
, enableXfce ? true
, enableMate ? true
, enableOpenbox ? true
, enableGtkNext ? false
, enablePlank ? false
, enableTelegram ? false
, enableTweetdeck ? false
, withSelectionColor ? null # Primary color for 'selected-items' (Default: #3F51B5 = Indigo500)
, withAccentColor ? null # Secondary color for notifications and OSDs (Default: #7986CB = Indigo300)
, withSuggestionColor ? null # Secondary color for 'suggested' buttons (Default: #673AB7 = DPurple500)
, withDestructionColor ? null # Tertiary color for 'destructive' buttons (Default: #F44336 = Red500)
}:

stdenv.mkDerivation rec {
  name = "adapta-gtk-theme-${version}";
  version = "3.95.0.1";

  src = fetchFromGitHub {
    owner = "adapta-project";
    repo = "adapta-gtk-theme";
    rev = version;
    sha256 = "0hc3ar55wjg51qf8c7h0nix0lyqs16mk1d4hhxyv102zq4l5fz97";
  };

  preferLocalBuild = true;

  nativeBuildInputs = [
    autoreconfHook
    pkgconfig
    parallel
    sassc
    inkscape
    libxml2
    glib.dev
    gnome3.gnome-shell
  ];

  buildInputs = [
    gdk_pixbuf
    librsvg
  ];

  propagatedUserEnvPkgs = [ gtk-engine-murrine ];

  postPatch = "patchShebangs .";

  configureFlags =
    let
      inherit (stdenv.lib) enableFeature optional;
      withOptional = feat: value: optional (value != null) "--with-${feat}=${value}";
    in [
      "--enable-parallel"
      (enableFeature enableGnome "gnome")
      (enableFeature enableCinnamon "cinnamon")
      (enableFeature enableFlashback "flashback")
      (enableFeature enableXfce "xfce")
      (enableFeature enableMate "mate")
      (enableFeature enableOpenbox "openbox")
      (enableFeature enableGtkNext "gtk_next")
    ]
    ++ (withOptional "selection_color" withSelectionColor)
    ++ (withOptional "accent_color" withAccentColor)
    ++ (withOptional "suggestion_color" withSuggestionColor)
    ++ (withOptional "destruction_color" withDestructionColor);

  meta = with stdenv.lib; {
    description = "An adaptive Gtk+ theme based on Material Design Guidelines";
    homepage = https://github.com/adapta-project/adapta-gtk-theme;
    license = with licenses; [ gpl2 cc-by-sa-30 ];
    platforms = platforms.linux;
    maintainers = [ maintainers.romildo ];
  };
}
