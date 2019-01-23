{ stdenv, fetchurl, fetchFromGitHub, autoreconfHook, gconf, intltool, makeWrapper, pkgconfig
, vala, wrapGAppsHook, dbus, dconf ? null, glib, gdk_pixbuf, gobject-introspection, gtk2
, gtk3, gtk-doc, isocodes, python3, json-glib, libnotify ? null, enablePythonLibrary ? true
, enableUI ? true, withWayland ? false, libxkbcommon ? null, wayland ? null
, buildPackages }:

assert withWayland -> wayland != null && libxkbcommon != null;

with stdenv.lib;

let
  emojiSrcs = {
    data = fetchurl {
      url = "http://unicode.org/Public/emoji/5.0/emoji-data.txt";
      sha256 = "11jfz5rrvyc2ixliqfcjgmch4cn9mfy0x96qnpfcyz5fy1jvfyxf";
    };
    sequences = fetchurl {
      url = "http://unicode.org/Public/emoji/5.0/emoji-sequences.txt";
      sha256 = "09bii7f5mmladg0kl3n80fa9qaix6bv5ylm92x52j7wygzv0szb1";
    };
    variation-sequences = fetchurl {
      url = "http://unicode.org/Public/emoji/5.0/emoji-variation-sequences.txt";
      sha256 = "1wlg4gbq7spmpppjfy5zdl82sj0hc836p8gljgfrjmwsjgybq286";
    };
    zwj-sequences = fetchurl {
      url = "http://unicode.org/Public/emoji/5.0/emoji-zwj-sequences.txt";
      sha256 = "16gvzv76mjv9g81lm1m6cr3rpfqyn2k4hb9a62xd329252dhl25q";
    };
    test = fetchurl {
      url = "http://unicode.org/Public/emoji/5.0/emoji-test.txt";
      sha256 = "031qk2v8xdnba7hfinmgrmpglc9l8ll2hds6mw885p0hngdb3dgw";
    };
  };
  emojiData = stdenv.mkDerivation {
    name = "emoji-data-5.0";
    unpackPhase = ":";
    installPhase = ''
      mkdir $out
      ${builtins.toString (flip mapAttrsToList emojiSrcs (k: v: "cp ${v} $out/emoji-${k}.txt;"))}
    '';
  };
  cldrEmojiAnnotation = stdenv.mkDerivation rec {
    name = "cldr-emoji-annotation-${version}";
    version = "31.90.0_1";
    src = fetchFromGitHub {
      owner = "fujiwarat";
      repo = "cldr-emoji-annotation";
      rev = version;
      sha256 = "1vsj32bg8ab4d80rz0fxy6sj2lv31inzyjnddjm079bnvlaf2kih";
    };
    nativeBuildInputs = [ autoreconfHook ];
  };
  python3Runtime = python3.withPackages (ps: with ps; [ pygobject3 ]);
  python3BuildEnv = python3.buildEnv.override {
    # ImportError: No module named site
    postBuild = ''
      makeWrapper ${glib.dev}/bin/gdbus-codegen $out/bin/gdbus-codegen --unset PYTHONPATH
      makeWrapper ${glib.dev}/bin/glib-genmarshal $out/bin/glib-genmarshal --unset PYTHONPATH
      makeWrapper ${glib.dev}/bin/glib-mkenums $out/bin/glib-mkenums --unset PYTHONPATH
    '';
  };
in

stdenv.mkDerivation rec {
  name = "ibus-${version}";
  version = "1.5.17";

  src = fetchFromGitHub {
    owner = "ibus";
    repo = "ibus";
    rev = version;
    sha256 = "09mrj9d8qpl9cbylg1zx8c3ymc5gdy4jrf6zs125wjz0b574g5av";
  };

  postPatch = ''
    substituteInPlace setup/ibus-setup.in --subst-var-by PYTHON ${python3Runtime.interpreter}
    substituteInPlace data/dconf/Makefile.am --replace "dconf update" true
    substituteInPlace configure.ac --replace '$python2dir/ibus' $out/${python3.sitePackages}/ibus
    echo \#!${stdenv.shell} > data/dconf/make-dconf-override-db.sh
    cp ${buildPackages.gtk-doc}/share/gtk-doc/data/gtk-doc.make .
  '';

  preAutoreconf = "touch ChangeLog";
  preConfigure = "intltoolize";

  configureFlags = [
    "--disable-gconf"
    "--disable-memconf"
    (enableFeature (dconf != null) "dconf")
    (enableFeature (libnotify != null) "libnotify")
    (enableFeature withWayland "wayland")
    (enableFeature enablePythonLibrary "python-library")
    (enableFeature enableUI "ui")
    "--with-unicode-emoji-dir=${emojiData}"
    "--with-emoji-annotation-dir=${cldrEmojiAnnotation}/share/unicode/cldr/common/annotations"
  ];

  nativeBuildInputs = [
    autoreconfHook
    gconf
    gtk-doc
    intltool
    makeWrapper
    pkgconfig
    python3BuildEnv
    vala
    wrapGAppsHook
  ];

  propagatedBuildInputs = [ glib ];

  buildInputs = [
    dbus
    dconf
    gdk_pixbuf
    gobject-introspection
    gtk2
    gtk3
    isocodes
    json-glib
    libnotify
  ] ++ optionals withWayland [
    libxkbcommon
    wayland
  ];

  enableParallelBuilding = true;

  doCheck = false; # requires X11 daemon
  doInstallCheck = true;
  installCheckPhase = "$out/bin/ibus version";

  meta = {
    homepage = https://github.com/ibus/ibus;
    description = "Intelligent Input Bus, input method framework";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ttuegel yegortimoshenko ];
  };
}
