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
        sha256 = "0zfn3z61xy76yah3d24dd745qjssrib009m4nvqpnx4sf1r13i2x";
      };
      sequences = fetchurl {
        url = "http://unicode.org/Public/emoji/5.0/emoji-sequences.txt";
        sha256 = "0xzk7hi2a8macx9s5gj2pb36d38y8fa9001sj71g6kw25c2h94cn";
      };
      variation-sequences = fetchurl {
        url = "http://unicode.org/Public/emoji/5.0/emoji-variation-sequences.txt";
        sha256 = "1wlg4gbq7spmpppjfy5zdl82sj0hc836p8gljgfrjmwsjgybq286";
      };
      zwj-sequences = fetchurl {
        url = "http://unicode.org/Public/emoji/5.0/emoji-zwj-sequences.txt";
        sha256 = "0rrnk94mhm3k9vs74pvyvs4ir7f31f1libx7c196fmdqvp1qfafw";
      };
      test = fetchurl {
        url = "http://unicode.org/Public/emoji/5.0/emoji-test.txt";
        sha256 = "1dvxw5xp1xiy13c1p1c7l2xc9q8f8znk47kb7q8g7bbgbi21cq5m";
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
    python3
    intltool isocodes pkgconfig
    gtk2 gtk3 dconf
    json_glib
    dbus libnotify gobjectIntrospection wayland
  ];

  propagatedBuildInputs = [ glib python3.pkgs.pygobject3 ];

  nativeBuildInputs = [ wrapGAppsHook python3.pkgs.wrapPython ];

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

  postFixup = ''
    buildPythonPath $out
    patchPythonScript $out/share/ibus/setup/main.py
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
