{ stdenv, fetchFromGitHub,
autoconf, automake, clang_5, cmake, git, gnum4, libtool, ocaml, opam_1_2, openjdk, perl, pkgconfig, python2, rsync, sqlite, which, zlib, }:

stdenv.mkDerivation rec {
  pname = "infer";
  version = "0.15.0";
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "infer";
    #tag = "v0.15.0";
    rev = "8bda23fadcc51c6ed38a4c3a75be25a266e8f7b4";
    sha256 = "1fzm5s0cwah6jk37rrb9dsrfd61f2ird3av0imspyi4qyp6pyrm6";
  };

  case_fail = ./FailingTest.java;
  case_pass = ./PassingTest.java;

  dontUseCmakeConfigure = true;
  doCheck = false;

  depsBuildBuild = [ gnum4 git which ];

  #nativeBuildInputs = [ ];
  buildInputs = [
    autoconf
    automake
    # clang or gcc on linux for c/c obj analysis
    #clang_5
    # on mac for c/c obj analysis
    cmake
    # only for java analysis:
    openjdk
    ocaml
    opam_1_2
    perl
    pkgconfig
    python2
    # only on mac?
    sqlite
    zlib
  ];

  postUnpack = ''
    # make sure we can git clone stuff (opam pin add -k git)
    export GIT_SSL_NO_VERIFY=true

    export OPAMROOT=$out/opam
    export OCAML_VERSION='4.06.1+flambda'
    export INFER_OPAM_SWITCH=infer-$OCAML_VERSION

    mkdir -p $OPAMROOT
    opam init --no-setup
    opam switch set $INFER_OPAM_SWITCH --alias-of $OCAML_VERSION

    eval $(SHELL=bash opam config env --switch=$INFER_OPAM_SWITCH)

    # install opam deps
    opam pin add -k git lock 'https://github.com/rgrinberg/opam-lock'
    opam lock --install < $src/opam.lock
  '';

  preConfigure = ''
    ./autogen.sh
  '';

  configureFlags = [ "--disable-c-analyzers" ];

  buildPhase = "";
  installPhase = ''make install'';

  postInstall = ''
    #$out/bin/infer --fail-on-issue -- javac ${case_fail}
    #$out/bin/infer --fail-on-issue -- javac ${case_pass}
  '';

  meta = with stdenv.lib; {
    description = "";
    longDescription = ''
    '';
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ amar1729 ];
    platforms = platforms.all;
  };
}
