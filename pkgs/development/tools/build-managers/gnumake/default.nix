{
  lib,
  stdenv,
  fetchurl,
  autoreconfHook,
  gettext,
  guileSupport ? false,
  guile,
  texinfo,
  # avoid guile depend on bootstrap to prevent dependency cycles
  inBootstrap ? false,
  pkg-config,
  gnumake,
}:

let
  guileEnabled = guileSupport && !inBootstrap;
in

stdenv.mkDerivation (finalAttrs: {
  pname = "gnumake";
  version = "4.4.1";

  src = fetchurl {
    url = "mirror://gnu/make/make-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-3Rb7HWe/q3mnL16DkHNcSePo5wtJRaFasfgd23hlj7M=";
  };

  # To update patches:
  #  $ version=4.4.1
  #  $ git clone https://git.savannah.gnu.org/git/make.git
  #  $ cd make && git checkout -b nixpkgs $version
  #  $ git am --directory=../patches
  #  $ # make changes, resolve conflicts, etc.
  #  $ git format-patch --output-directory ../patches --diff-algorithm=histogram $version
  #
  # TODO: stdenv’s setup.sh should be aware of patch directories. It’s very
  # convenient to keep them in a separate directory but we can defer listing the
  # directory until derivation realization to avoid unnecessary Nix evaluations.
  patches = lib.filesystem.listFilesRecursive ./patches;

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ]
  ++ lib.optionals (!inBootstrap) [ texinfo ];

  buildInputs =
    lib.optionals guileEnabled [ guile ]
    # gettext gets pulled in via autoreconfHook because strictDeps is not set,
    # and is linked against. Without this, it doesn't end up in HOST_PATH.
    # TODO: enable strictDeps, and either make this dependency explicit, or remove it
    ++ lib.optional stdenv.isCygwin gettext;

  configureFlags =
    lib.optional guileEnabled "--with-guile"
    # fnmatch.c:124:14: error: conflicting types for 'getenv'; have 'char *(void)'
    ++ lib.optional stdenv.hostPlatform.isCygwin "CFLAGS=-std=gnu17";

  outputs = [
    "out"
    "man"
    "info"
  ]
  ++ lib.optionals (!inBootstrap) [ "doc" ];

  postBuild = lib.optionalString (!inBootstrap) ''
    makeinfo --html --no-split doc/make.texi
  '';

  postInstall = lib.optionalString (!inBootstrap) ''
    mkdir -p $doc/share/doc/$pname-$version
    cp ./make.html $doc/share/doc/$pname-$version/index.html
  '';

  separateDebugInfo = true;

  passthru.tests = {
    # make sure that the override doesn't break bootstrapping
    gnumakeWithGuile = gnumake.override { guileSupport = true; };
  };

  meta = {
    description = "Tool to control the generation of non-source files from sources";
    longDescription = ''
      Make is a tool which controls the generation of executables and
      other non-source files of a program from the program's source files.

      Make gets its knowledge of how to build your program from a file
      called the makefile, which lists each of the non-source files and
      how to compute it from other files. When you write a program, you
      should write a makefile for it, so that it is possible to use Make
      to build and install the program.
    '';
    homepage = "https://www.gnu.org/software/make/";
    license = lib.licenses.gpl3Plus;
    maintainers = [ lib.maintainers.mdaniels5757 ];
    mainProgram = "make";
    platforms = lib.platforms.all;
  };
})
