{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
, pkg-config
, coreutils
, emacs
, glib
, gmime3
, texinfo
, xapian
<<<<<<< HEAD
, fetchpatch
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

stdenv.mkDerivation rec {
  pname = "mu";
<<<<<<< HEAD
  version = "1.10.7";

  outputs = [ "out" "mu4e" ];
=======
  version = "1.10.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "djcb";
    repo = "mu";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-x1TsyTOK5U6/Y3QInm+XQ7T32X49iwa+4UnaHdiyqCI=";
  };

  patches = [
    (fetchpatch {
      name = "add-mu4e-pkg.el";
      url = "https://github.com/djcb/mu/commit/00f7053d51105eea0c72151f1a8cf0b6d8478e4e.patch";
      hash = "sha256-21c7djmYTcqyyygqByo9vu/GsH8WMYcq8NOAvJsS5AQ=";
    })
  ];

=======
    hash = "sha256-AqIPdKdNKLnAHIlqgs8zzm7j+iwNvDFWslvp8RjQPnI=";
  };

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  postPatch = ''
    # Fix mu4e-builddir (set it to $out)
    substituteInPlace mu4e/mu4e-config.el.in \
      --replace "@abs_top_builddir@" "$out"
    substituteInPlace lib/utils/mu-test-utils.cc \
      --replace "/bin/rm" "${coreutils}/bin/rm"
  '';

<<<<<<< HEAD
  postInstall = ''
    rm --verbose $mu4e/share/emacs/site-lisp/mu4e/*.elc
  '';

  # move only the mu4e info manual
  # this has to be after preFixup otherwise the info manual may be moved back by _multioutDocs()
  # we manually move the mu4e info manual instead of setting
  # outputInfo to mu4e because we do not want to move the mu-guile
  # info manual (if it exists)
  postFixup = ''
    moveToOutput share/info/mu4e.info.gz $mu4e
    install-info $mu4e/share/info/mu4e.info.gz $mu4e/share/info/dir
    if [[ -a ''${!outputInfo}/share/info/mu-guile.info.gz ]]; then
      install-info --delete $mu4e/share/info/mu4e.info.gz ''${!outputInfo}/share/info/dir
    else
      rm --verbose --recursive ''${!outputInfo}/share/info
    fi
=======
  # AOT native-comp, mostly copied from pkgs/build-support/emacs/generic.nix
  postInstall = lib.optionalString (emacs.nativeComp or false) ''
    mkdir -p $out/share/emacs/native-lisp
    export EMACSLOADPATH=$out/share/emacs/site-lisp/mu4e:
    export EMACSNATIVELOADPATH=$out/share/emacs/native-lisp:

    find $out/share/emacs -type f -name '*.el' -print0 \
      | xargs -0 -I {} -n 1 -P $NIX_BUILD_CORES sh -c \
          "emacs --batch --eval '(setq large-file-warning-threshold nil)' -f batch-native-compile {} || true"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  '';

  buildInputs = [ emacs glib gmime3 texinfo xapian ];

  mesonFlags = [
    "-Dguile=disabled"
    "-Dreadline=disabled"
<<<<<<< HEAD
    "-Dlispdir=${placeholder "mu4e"}/share/emacs/site-lisp"
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  nativeBuildInputs = [ pkg-config meson ninja ];

  doCheck = true;

  meta = with lib; {
    description = "A collection of utilities for indexing and searching Maildirs";
    license = licenses.gpl3Plus;
    homepage = "https://www.djcbsoftware.nl/code/mu/";
    changelog = "https://github.com/djcb/mu/releases/tag/v${version}";
    maintainers = with maintainers; [ antono chvp peterhoeg ];
<<<<<<< HEAD
    mainProgram = "mu";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    platforms = platforms.unix;
  };
}
