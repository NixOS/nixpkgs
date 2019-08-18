{ stdenv, substituteAll, fetchurl, fetchFromGitHub, autoreconfHook, gettext, makeWrapper, pkgconfig
, vala, wrapGAppsHook, dbus, dconf ? null, glib, gdk-pixbuf, gobject-introspection, gtk2
, gtk3, gtk-doc, isocodes, python3, json-glib, libnotify ? null, enablePython2Library ? false
, enableUI ? true, withWayland ? false, libxkbcommon ? null, wayland ? null
, buildPackages, runtimeShell }:

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
    dontUnpack = true;
    installPhase = ''
      mkdir $out
      ${builtins.toString (flip mapAttrsToList emojiSrcs (k: v: "cp ${v} $out/emoji-${k}.txt;"))}
    '';
  };
  cldrEmojiAnnotation = stdenv.mkDerivation rec {
    pname = "cldr-emoji-annotation";
    version = "31.90.0_1";
    src = fetchFromGitHub {
      owner = "fujiwarat";
      repo = "cldr-emoji-annotation";
      rev = version;
      sha256 = "1vsj32bg8ab4d80rz0fxy6sj2lv31inzyjnddjm079bnvlaf2kih";
    };
    nativeBuildInputs = [ autoreconfHook ];
  };
  ucdSrcs = {
    NamesList = fetchurl {
      url = "https://www.unicode.org/Public/UNIDATA/NamesList.txt";
      sha256 = "c17c7726f562bd9ef869096807f0297e1edef9a58fdae1fbae487378fa43586f";
    };
    Blocks = fetchurl {
      url = "https://www.unicode.org/Public/UNIDATA/Blocks.txt";
      sha256 = "a1a3ca4381eb91f7b65afe7cb7df615cdcf67993fef4b486585f66b349993a10";
    };
  };
  ucd = stdenv.mkDerivation rec {
    name = "ucd-12.0.0";
    dontUnpack = true;
    installPhase = ''
      mkdir $out
      ${builtins.toString (flip mapAttrsToList ucdSrcs (k: v: "cp ${v} $out/${k}.txt;"))}
    '';
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
  pname = "ibus";
  version = "1.5.20";

  src = fetchFromGitHub {
    owner = "ibus";
    repo = "ibus";
    rev = version;
    sha256 = "1npavb896qrp6qbqayb0va4mpsi68wybcnlbjknzgssqyw2ylh9r";
  };

  patches = [
    (substituteAll {
      src = ./fix-paths.patch;
      pythonInterpreter = python3Runtime.interpreter;
      pythonSitePackages = python3.sitePackages;
    })
  ];

  postPatch = ''
    echo \#!${runtimeShell} > data/dconf/make-dconf-override-db.sh
    cp ${buildPackages.gtk-doc}/share/gtk-doc/data/gtk-doc.make .
  '';

  preAutoreconf = "touch ChangeLog";

  configureFlags = [
    "--disable-memconf"
    (enableFeature (dconf != null) "dconf")
    (enableFeature (libnotify != null) "libnotify")
    (enableFeature withWayland "wayland")
    (enableFeature enablePython2Library "python-library")
    (enableFeature enablePython2Library "python2") # XXX: python2 library does not work anyway
    (enableFeature enableUI "ui")
    "--with-unicode-emoji-dir=${emojiData}"
    "--with-emoji-annotation-dir=${cldrEmojiAnnotation}/share/unicode/cldr/common/annotations"
    "--with-ucd-dir=${ucd}"
  ];

  nativeBuildInputs = [
    autoreconfHook
    gtk-doc
    gettext
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
    gdk-pixbuf
    gobject-introspection
    python3.pkgs.pygobject3 # for pygobject overrides
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
