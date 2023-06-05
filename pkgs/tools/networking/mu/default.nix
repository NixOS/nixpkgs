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
}:

stdenv.mkDerivation rec {
  pname = "mu";
  version = "1.10.3";

  src = fetchFromGitHub {
    owner = "djcb";
    repo = "mu";
    rev = "v${version}";
    hash = "sha256-AqIPdKdNKLnAHIlqgs8zzm7j+iwNvDFWslvp8RjQPnI=";
  };

  postPatch = ''
    # Fix mu4e-builddir (set it to $out)
    substituteInPlace mu4e/mu4e-config.el.in \
      --replace "@abs_top_builddir@" "$out"
    substituteInPlace lib/utils/mu-test-utils.cc \
      --replace "/bin/rm" "${coreutils}/bin/rm"
  '';

  # AOT native-comp, mostly copied from pkgs/build-support/emacs/generic.nix
  postInstall = lib.optionalString (emacs.withNativeCompilation or false) ''
    mkdir -p $out/share/emacs/native-lisp
    export EMACSLOADPATH=$out/share/emacs/site-lisp/mu4e:
    export EMACSNATIVELOADPATH=$out/share/emacs/native-lisp:

    find $out/share/emacs -type f -name '*.el' -print0 \
      | xargs -0 -I {} -n 1 -P $NIX_BUILD_CORES sh -c \
          "emacs --batch --eval '(setq large-file-warning-threshold nil)' -f batch-native-compile {} || true"
  '' + ''
    emacs --batch -l package --eval "(package-generate-autoloads \"mu4e\" \"$out/share/emacs/site-lisp/mu4e\")"
  '';

  buildInputs = [ emacs glib gmime3 texinfo xapian ];

  mesonFlags = [
    "-Dguile=disabled"
    "-Dreadline=disabled"
  ];

  nativeBuildInputs = [ pkg-config meson ninja ];

  doCheck = true;

  meta = with lib; {
    description = "A collection of utilities for indexing and searching Maildirs";
    license = licenses.gpl3Plus;
    homepage = "https://www.djcbsoftware.nl/code/mu/";
    changelog = "https://github.com/djcb/mu/releases/tag/v${version}";
    maintainers = with maintainers; [ antono chvp peterhoeg ];
    platforms = platforms.unix;
  };
}
