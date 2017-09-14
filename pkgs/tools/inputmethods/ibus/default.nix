{ stdenv, fetchurl, wrapGAppsHook
, intltool, isocodes, pkgconfig
, python3
, gtk2, gtk3, atk, dconf, glib, json_glib
, dbus, libnotify, gobjectIntrospection, wayland
}:

let
  emojiData = let
    srcs = {
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
  in stdenv.mkDerivation {
    name = "emoji-data-5.0";
    unpackPhase = ":";
    dontBuild = true;
    installPhase = with stdenv.lib; ''
      mkdir $out
      ${builtins.toString (flip mapAttrsToList srcs (k: v: ''
        cp ${v} $out/emoji-${k}.txt
      ''))}
    '';
  };
  cldrEmojiAnnotation = stdenv.mkDerivation rec {
    name = "cldr-emoji-annotation-${version}";
    version = "31.0.1_1";
    src = fetchurl {
      url = "https://github.com/fujiwarat/cldr-emoji-annotation/releases/download/${version}/${name}.tar.gz";
      sha256 = "1a3qzsab7vzjqpdialp1g8ppr21x05v0ph8ngyq9pyjkx4vzcdi7";
    };
  };
  pyEnv = python3.buildEnv.override {
    extraLibs = [ python3.pkgs.pygobject3 ];
  };
in stdenv.mkDerivation rec {
  name = "ibus-${version}";
  version = "1.5.16";

  src = fetchurl {
    url = "https://github.com/ibus/ibus/releases/download/${version}/${name}.tar.gz";
    sha256 = "07py16jb81kd7vkqhcia9cb2avsbg5jswp2kzf0k4bprwkxppd9n";
  };

  postPatch = ''
    # These paths will be set in the wrapper.
    sed -e "/export IBUS_DATAROOTDIR/ s/^.*$//" \
        -e "/export IBUS_LIBEXECDIR/ s/^.*$//" \
        -e "/export IBUS_LOCALEDIR/ s/^.*$//" \
        -e "/export IBUS_PREFIX/ s/^.*$//" \
        -i "setup/ibus-setup.in"
  '';

  configureFlags = [
    "--disable-gconf"
    "--enable-dconf"
    "--disable-memconf"
    "--enable-ui"
    "--enable-python-library"
    "--with-unicode-emoji-dir=${emojiData}"
    "--with-emoji-annotation-dir=${cldrEmojiAnnotation}/share/unicode/cldr/common/annotations"
  ];

  buildInputs = [
    pyEnv
    intltool isocodes pkgconfig
    gtk2 gtk3 dconf
    json_glib
    dbus libnotify gobjectIntrospection wayland
  ];

  propagatedBuildInputs = [ glib ];

  nativeBuildInputs = [ wrapGAppsHook ];

  outputs = [ "out" "dev" ];

  enableParallelBuilding = true;

  preConfigure = ''
    # Fix hard-coded installation paths, so make does not try to overwrite our
    # Python installation.
    sed -e "/py2overridesdir=/ s|=.*$|=$out/lib/${python3.libPrefix}|" \
        -e "/pyoverridesdir=/ s|=.*$|=$out/lib/${python3.libPrefix}|" \
        -e "/PYTHON2_LIBDIR/ s|=.*|=$out/lib/${python3.libPrefix}|" \
        -i configure

    # Don't try to generate a system-wide dconf database; it wouldn't work.
    substituteInPlace data/dconf/Makefile.in --replace "dconf update" "echo"
  '';

  doInstallCheck = true;
  installCheckPhase = "$out/bin/ibus version";

  meta = with stdenv.lib; {
    homepage = https://github.com/ibus/ibus;
    description = "Intelligent Input Bus for Linux / Unix OS";
    platforms = platforms.linux;
    maintainers = [ maintainers.ttuegel ];
  };
}
