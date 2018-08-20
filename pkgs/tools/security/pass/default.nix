{ stdenv, lib, pkgs, fetchurl, buildEnv
, coreutils, gnused, getopt, git, tree, gnupg, which, procps, qrencode
, makeWrapper

, xclip ? null, xdotool ? null, dmenu ? null
, x11Support ? !stdenv.isDarwin

# For backwards-compatibility
, tombPluginSupport ? false
}:

with lib;

assert x11Support -> xclip != null
                  && xdotool != null
                  && dmenu != null;

let
  passExtensions = import ./extensions { inherit pkgs; };

  env = extensions:
    let
      selected = extensions passExtensions
        ++ stdenv.lib.optional tombPluginSupport passExtensions.tomb;
    in buildEnv {
      name = "pass-extensions-env";
      paths = selected;
      buildInputs = concatMap (x: x.buildInputs) selected;
    };

  generic = extensionsEnv: extraPassthru: stdenv.mkDerivation rec {
    version = "1.7.3";
    name    = "password-store-${version}";

    src = fetchurl {
      url    = "https://git.zx2c4.com/password-store/snapshot/${name}.tar.xz";
      sha256 = "1x53k5dn3cdmvy8m4fqdld4hji5n676ksl0ql4armkmsds26av1b";
    };

    patches = [ ./set-correct-program-name-for-sleep.patch
              ] ++ stdenv.lib.optional stdenv.isDarwin ./no-darwin-getopt.patch;

    nativeBuildInputs = [ makeWrapper ];

    buildInputs = [ extensionsEnv ];

    installFlags = [ "PREFIX=$(out)" "WITH_ALLCOMP=yes" ];

    postInstall = ''
      # Install Emacs Mode. NOTE: We can't install the necessary
      # dependencies (s.el and f.el) here. The user has to do this
      # himself.
      mkdir -p "$out/share/emacs/site-lisp"
      cp "contrib/emacs/password-store.el" "$out/share/emacs/site-lisp/"
    '' + optionalString x11Support ''
      cp "contrib/dmenu/passmenu" "$out/bin/"
    '';

    wrapperPath = with stdenv.lib; makeBinPath ([
      coreutils
      getopt
      git
      gnupg
      gnused
      tree
      which
      qrencode
      procps
    ] ++ ifEnable x11Support [ dmenu xclip xdotool ]);

    postFixup = ''
      # Link extensions env
      rmdir $out/lib/password-store/extensions
      ln -s ${extensionsEnv}/lib/password-store/extensions $out/lib/password-store/.

      # Fix program name in --help
      substituteInPlace $out/bin/pass \
        --replace 'PROGRAM="''${0##*/}"' "PROGRAM=pass"

      # Ensure all dependencies are in PATH
      wrapProgram $out/bin/pass \
        --prefix PATH : "${wrapperPath}"
    '' + stdenv.lib.optionalString x11Support ''
      # We just wrap passmenu with the same PATH as pass. It doesn't
      # need all the tools in there but it doesn't hurt either.
      wrapProgram $out/bin/passmenu \
        --prefix PATH : "$out/bin:${wrapperPath}"
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
    '';

    doCheck = false;

    doInstallCheck = true;
    installCheckInputs = [ git ];
    installCheckTarget = "test";

    passthru = {
      extensions = passExtensions;
    } // extraPassthru;

    meta = with stdenv.lib; {
      description = "Stores, retrieves, generates, and synchronizes passwords securely";
      homepage    = https://www.passwordstore.org/;
      license     = licenses.gpl2Plus;
      maintainers = with maintainers; [ lovek323 the-kenny fpletz tadfisher ];
      platforms   = platforms.unix;

      longDescription = ''
        pass is a very simple password store that keeps passwords inside gpg2
        encrypted files inside a simple directory tree residing at
        ~/.password-store. The pass utility provides a series of commands for
        manipulating the password store, allowing the user to add, remove, edit,
        synchronize, generate, and manipulate passwords.
      '';
    };
  };

in

generic (env (_: [])) {
  withExtensions = extensions: generic (env extensions) {};
}
