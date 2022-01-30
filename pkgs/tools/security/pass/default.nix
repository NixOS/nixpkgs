{ stdenv
, lib
, pkgs
, fetchurl
, buildEnv
, coreutils
, findutils
, gnugrep
, gnused
, getopt
, git
, tree
, gnupg
, openssl
, which
, procps
, qrencode
, makeWrapper
, pass
, symlinkJoin

, xclip ? null
, xdotool ? null
, dmenu ? null
, x11Support ? !stdenv.isDarwin
, dmenuSupport ? (x11Support || waylandSupport)
, waylandSupport ? false
, wl-clipboard ? null
, ydotool ? null
, dmenu-wayland ? null

  # For backwards-compatibility
, tombPluginSupport ? false

, resholvePackage
, bash
, libsForQt5
, feh
, graphicsmagick
, imagemagick
, diffutils
}:

let
  passExtensions = import ./extensions { inherit pkgs; };

  env = extensions:
    let
      selected = [ pass ] ++ extensions passExtensions
        ++ lib.optional tombPluginSupport passExtensions.tomb;
    in
    buildEnv {
      name = "pass-extensions-env";
      paths = selected;
      buildInputs = [ makeWrapper ] ++ lib.concatMap (x: x.buildInputs) selected;

      postBuild = ''
        files=$(find $out/bin/ -type f -exec readlink -f {} \;)
        if [ -L $out/bin ]; then
          rm $out/bin
          mkdir $out/bin
        fi

        for i in $files; do
          if ! [ "$(readlink -f "$out/bin/$(basename $i)")" = "$i" ]; then
            ln -sf $i $out/bin/$(basename $i)
          fi
        done

        wrapProgram $out/bin/pass \
          --set SYSTEM_EXTENSION_DIR "$out/lib/password-store/extensions"
      '';
    };
in

resholvePackage rec {
  version = "1.7.4";
  pname = "password-store";

  src = fetchurl {
    url = "https://git.zx2c4.com/password-store/snapshot/${pname}-${version}.tar.xz";
    sha256 = "1h4k6w7g8pr169p5w9n6mkdhxl3pw51zphx7www6pvgjb7vgmafg";
  };

  patches = [
    ./set-correct-program-name-for-sleep.patch
    ./extension-dir.patch
  ] ++ lib.optional stdenv.isDarwin ./no-darwin-getopt.patch;

  nativeBuildInputs = [ makeWrapper ];

  installFlags = [ "PREFIX=$(out)" "WITH_ALLCOMP=yes" ];

  postInstall = ''
    # Install Emacs Mode. NOTE: We can't install the necessary
    # dependencies (s.el) here. The user has to do this themselves.
    mkdir -p "$out/share/emacs/site-lisp"
    cp "contrib/emacs/password-store.el" "$out/share/emacs/site-lisp/"
  '' + lib.optionalString dmenuSupport ''
    cp "contrib/dmenu/passmenu" "$out/bin/"
  '';

  solutions = {
    pass = {
      scripts = [ "bin/pass" ] ++ lib.optional (!stdenv.isLinux) "lib/password-store/platform.sh";
      interpreter = "${bash}/bin/bash";
      inputs = [
        gnused
        gnupg
        coreutils
        getopt
        which
        git
        gnugrep
        findutils
        procps
        bash
        libsForQt5.qt5.qttools.bin
        qrencode
        feh
        graphicsmagick
        imagemagick
        tree
        diffutils
        # TODO: I assume linux builds will pop w/o below
      ] ++ lib.optionals waylandSupport [
        wl-clipboard
      ] ++ lib.optionals (x11Support && !waylandSupport) [
        xclip
      ];
      fake = { } // lib.optionalAttrs stdenv.isDarwin {
        # caution: these will still be fragile if PATH is bad
        # TODO: fixable once we figure out how to handle
        # this entire class of problem...
        external = [
          # procps doesn't contain pkill/pgrep on macOS
          "pkill"
          # the rest of these are in platform.sh only
          "pgrep"
          "pbpaste" "pbcopy" # also system/impure
          # setuid https://github.com/abathur/resholve/issues/29
          "umount"
          "diskutil"
          "hdid"
          "newfs_hfs"
          "mount"

          # TODO: used to display a QR code, but neither imgcat in
          # nixpkgs works when used like this. It's possible that this
          # is https://iterm2.com/utilities/imgcat, but I'm not going
          # to tack that on for now--qrencode still emits a visible
          # representation of the QR code even without this.
          "imgcat"
        ];
      };
      fix = {
        "$GPG" = [ "gpg2" ];
        "$BASE64" = [ "base64" ];
        "$GETOPT" = [ "getopt" ];
        # inner quotes re: https://github.com/abathur/resholve/issues/32
        "$SHRED" = [ "'shred -f -z'" ];
      };
      keep = {
        "$paste_cmd" = true; # dynamic, depends on user env
        "$copy_cmd" = true; # dynamic, depends on user env
        "$EDITOR" = true; # dynamic, depends on user env

        source = [
          "$extension" # internal, for pass extensions
          # `make install` bakes in $out into the source statement
          # easier to let it slide than to patch it...
          "${placeholder "out"}/lib/password-store/platform.sh"
        ];
      };

      /*
      These are all a _bit_ of a lie. There's a chicken-and-egg problem w/
      having enough human bandwidth to triage these for special-casing in
      binlore and resholve, and getting enough packages resholved to spread
      the word... for now, I just hand-audit invocations of potential execers
      and add override the lore to say it can't exec if it seems safe.
      */
      execer = [
        /*
        One git invocation here is a genuinely tricky case:
        https://github.com/zx2c4/password-store/blob/eea24967a002a2a81ae9b97a1fe972b5287f3a09/src/password-store.sh#L662

        It looks like the config value will get execed later, but since it's
        getting added to the local config of the pass repo on init, it seems
        like a store path could end up breaking later once the version that
        initialized the pass repo is no longer present? I don't know how
        critical this specific behavior is.

        (since git is so massive, it's likely to linger on the to-do list
        until others can step up to help sort it out...)
        */
        "cannot:${git}/bin/git"
        "cannot:${gnupg}/bin/gpg2"
        "cannot:${procps}/bin/pkill"
        "cannot:${feh}/bin/feh"
        "cannot:${tree}/bin/tree"
        "cannot:${diffutils}/bin/diff"
      ];
    };

  } // lib.optionalAttrs dmenuSupport {
    passmenu = {
      scripts = [ "bin/passmenu" ];
      interpreter = "${bash}/bin/bash";
      inputs = [ ] ++ lib.optionals waylandSupport [
        dmenu-wayland
        ydotool
      ] ++ lib.optionals (x11Support && !waylandSupport) [
        dmenu
        xdotool
      ];
      fake = {
        # TODO: temporary until package-internal deps have a better fix
        external = [ "pass" ];
      };
      fix = {} // lib.optionalAttrs waylandSupport {
        "$dmenu" = [ "dmenu-wl" ];
        "$xdotool" = [ "'ydotool type --file -'" ];
      } // lib.optionalAttrs (x11Support && !waylandSupport) {
        "$dmenu" = [ "dmenu" ];
        "$xdotool" = [ "'xdotool type --clearmodifiers --file -'" ];
      } // lib.optionalAttrs (!x11Support && !waylandSupport) {
        # I'm not sure this condition is "real"; I see it while
        # forcing dmenuSupport=true to test from macOS :)
      };
      keep = {} // lib.optionalAttrs (!x11Support && !waylandSupport) {
        # I'm not sure this condition is "real"; I see it while
        # forcing dmenuSupport=true to test from macOS :)
        "$dmenu" = true;
        "$xdotool" = true;
      };
      execer = [ ] ++ lib.optionals waylandSupport [
        # I didn't actually confirm this one is necessary
        # just guessing per xdotool below
        "cannot:${ydotool}/bin/ydotool"
      ] ++ lib.optionals (x11Support && !waylandSupport) [
        "cannot:${xdotool}/bin/xdotool"
      ];
    };
  };

  postFixup = ''
    # Fix program name in --help
    substituteInPlace $out/bin/pass \
      --replace 'PROGRAM="''${0##*/}"' "PROGRAM=pass"
  ''
  # TODO: drop below after resholve has a way to handle intra-package
  # executable invocations; https://github.com/abathur/resholve/issues/26
  + lib.optionalString dmenuSupport ''
    substituteInPlace $out/bin/passmenu \
      --replace "pass show" "$out/pass/show"
  '';

  # Turn "check" into "installcheck", since we want to test our pass,
  # not the one before the fixup.
  postPatch = ''
    patchShebangs tests

    # the turning
    sed -i -e 's@^PASS=.*''$@PASS=$out/bin/pass@' \
           -e 's@^GPGS=.*''$@GPG=${gnupg}/bin/gpg2@' \
           -e '/which gpg/ d' \
      tests/setup.sh
  '' + lib.optionalString stdenv.isDarwin ''
    # 'pass edit' uses hdid, which is not available from the sandbox.
    rm -f tests/t0200-edit-tests.sh
    rm -f tests/t0010-generate-tests.sh
    rm -f tests/t0020-show-tests.sh
    rm -f tests/t0050-mv-tests.sh
    rm -f tests/t0100-insert-tests.sh
    rm -f tests/t0300-reencryption.sh
    rm -f tests/t0400-grep.sh
  '';

  doCheck = false;

  doInstallCheck = true;
  installCheckInputs = [ git ];
  installCheckTarget = "test";

  passthru = {
    extensions = passExtensions;
    withExtensions = env;
  };

  meta = with lib; {
    description = "Stores, retrieves, generates, and synchronizes passwords securely";
    homepage = "https://www.passwordstore.org/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ lovek323 fpletz tadfisher globin ma27 ];
    platforms = platforms.unix;

    longDescription = ''
      pass is a very simple password store that keeps passwords inside gpg2
      encrypted files inside a simple directory tree residing at
      ~/.password-store. The pass utility provides a series of commands for
      manipulating the password store, allowing the user to add, remove, edit,
      synchronize, generate, and manipulate passwords.
    '';
  };
}
