{ stdenv,
autoconf, automake, git, gnum4, ocaml, opam_1_2, perl, pkgconfig, python2, sqlite, which, zlib, }:

stdenv.mkDerivation rec {
  name = "infer-deps";
  version = "0.15.0"; # version-locked to infer

  src = ./.; # this is a trivial package - just opam deps for infer!

  opamlock = ./opam.lock;

  dontBuild = true;

  # only need git for installing and using opam-lock
  depsBuildBuild = [ git ];

  buildInputs = [
    autoconf
	automake
	gnum4
    ocaml
    opam_1_2
    perl
    pkgconfig
    sqlite
    which
    zlib
  ];

  installPhase = "
    # make sure we can git clone stuff (opam pin add -k git)
    export GIT_SSL_NO_VERIFY=true

    export OPAMROOT=$out/opam
    export OCAML_VERSION='4.06.1+flambda'
    export INFER_OPAM_SWITCH=infer-$OCAML_VERSION

    mkdir -p $OPAMROOT
    opam init --no-setup
    opam switch set $INFER_OPAM_SWITCH --alias-of $OCAML_VERSION

    eval $(SHELL=bash opam config env --switch=$INFER_OPAM_SWITCH)

    # install infer deps
	opam pin add -k git lock 'https://github.com/rgrinberg/opam-lock'
	opam lock --install < ${opamlock}
  ";

  meta = with stdenv.lib; {
    description = "Opam dependencies for infer";
    longDescription = ''
      Dependencies opam/ocaml for static analysis tool infer.
      Provided as a separate package to keep builds clean, since
      both infer and facebook-clang-plugins depend on this.
    '';
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ amar1729 ];
    platforms = platforms.all;
  };
}
