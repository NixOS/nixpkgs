# Overlay that builds static packages.

# Not all packages will build but support is done on a
# best effort basic.
#
# Note on Darwin/macOS: Apple does not provide a static libc
# so any attempts at static binaries are going to be very
# unsupported.
#
# Basic things like pkgsStatic.hello should work out of the box. More
# complicated things will need to be fixed with overrides.

self: super: let
  inherit (super.stdenvAdapters) makeStaticBinaries
                                 overrideInStdenv
                                 makeStaticLibraries;
  inherit (super.lib) foldl optional flip id optionalAttrs composeExtensions;
  inherit (super) makeSetupHook;

  # Best effort static binaries. Will still be linked to libSystem,
  # but more portable than Nix store binaries.
  makeStaticDarwin = stdenv: stdenv // {
    mkDerivation = args: stdenv.mkDerivation (args // {
      NIX_CFLAGS_LINK = toString (args.NIX_CFLAGS_LINK or "")
                      + " -static-libgcc";
      nativeBuildInputs = (args.nativeBuildInputs or []) ++ [ (makeSetupHook {
        substitutions = {
          libsystem = "${stdenv.cc.libc}/lib/libSystem.B.dylib";
        };
      } ../stdenv/darwin/portable-libsystem.sh) ];
    });
  };

  staticAdapters = [ makeStaticLibraries ]

    # Apple does not provide a static version of libSystem or crt0.o
    # So we can’t build static binaries without extensive hacks.
    ++ optional (!super.stdenv.hostPlatform.isDarwin) makeStaticBinaries

    ++ optional super.stdenv.hostPlatform.isDarwin makeStaticDarwin

    # Glibc doesn’t come with static runtimes by default.
    # ++ optional (super.stdenv.hostPlatform.libc == "glibc") ((flip overrideInStdenv) [ self.stdenv.glibc.static ])
  ;

  # Force everything to link statically.
  haskellStaticAdapter = self: super: {
    mkDerivation = attrs: super.mkDerivation (attrs // {
      enableSharedLibraries = false;
      enableSharedExecutables = false;
      enableStaticLibraries = true;
    });
  };

in {
  stdenv = foldl (flip id) super.stdenv staticAdapters;

  haskell = super.haskell // {
    packageOverrides = composeExtensions
      (super.haskell.packageOverrides or (_: _: {}))
      haskellStaticAdapter;
  };

  ncurses = super.ncurses.override {
    enableStatic = true;
  };
  libxml2 = super.libxml2.override {
    enableShared = false;
    enableStatic = true;
  };
  zlib = super.zlib.override {
    static = true;
    shared = false;

    # Don’t use new stdenv zlib because
    # it doesn’t like the --disable-shared flag
    stdenv = super.stdenv;
  };
  xz = super.xz.override {
    enableStatic = true;
  };
  busybox = super.busybox.override {
    enableStatic = true;
  };
  v8 = super.v8.override {
    static = true;
  };
  libiberty = super.libiberty.override {
    staticBuild = true;
  };
  ipmitool = super.ipmitool.override {
    static = true;
  };
  neon = super.neon.override {
    static = true;
    shared = false;
  };
  libjpeg = super.libjpeg.override {
    static = true;
  };
  gifsicle = super.gifsicle.override {
    static = true;
  };
  bzip2 = super.bzip2.override {
    linkStatic = true;
  };
  optipng = super.optipng.override {
    static = true;
  };
  openssl = super.openssl.override {
    static = true;

    # Don’t use new stdenv for openssl because it doesn’t like the
    # --disable-shared flag
    stdenv = super.stdenv;
  };
  boost = super.boost.override {
    enableStatic = true;
    enableShared = false;
  };
  gmp = super.gmp.override {
    withStatic = true;
  };
  cdo = super.cdo.override {
    enable_all_static = true;
  };
  gsm = super.gsm.override {
    staticSupport = true;
  };
  parted = super.parted.override {
    enableStatic = true;
  };
  libiconvReal = super.libiconvReal.override {
    enableShared = false;
    enableStatic = true;
  };
  perl = super.perl.override {
    # Don’t use new stdenv zlib because
    # it doesn’t like the --disable-shared flag
    stdenv = super.stdenv;
  };
  lz4 = super.lz4.override {
    enableShared = false;
    enableStatic = true;
  };

  darwin = super.darwin // {
    libiconv = super.darwin.libiconv.override {
      enableShared = false;
      enableStatic = true;
    };
  };

}
