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
                                 makeStaticLibraries
                                 propagateBuildInputs;
  inherit (super.lib) foldl optional flip id composeExtensions optionalAttrs;
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

  staticAdapters = [ makeStaticLibraries propagateBuildInputs ]

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

  removeUnknownConfigureFlags = f: with self.lib;
    remove "--disable-shared"
    (remove "--enable-static" f);

  ocamlFixPackage = b:
    b.overrideAttrs (o: {
      configurePlatforms = [ ];
      configureFlags = removeUnknownConfigureFlags (o.configureFlags or [ ]);
      buildInputs = o.buildInputs ++ o.nativeBuildInputs or [ ];
      propagatedNativeBuildInputs = o.propagatedBuildInputs or [ ];
    });

  ocamlStaticAdapter = _: super:
    self.lib.mapAttrs
      (_: p: if p ? overrideAttrs then ocamlFixPackage p else p)
      super
    // {
      lablgtk = null; # Currently xlibs cause infinite recursion
      ocaml = ((super.ocaml.override { useX11 = false; }).overrideAttrs (o: {
        configurePlatforms = [ ];
        dontUpdateAutotoolsGnuConfigScripts = true;
      })).overrideDerivation (o: {
        preConfigure = ''
          configureFlagsArray+=("-cc" "$CC" "-as" "$AS" "-partialld" "$LD -r")
        '';
        configureFlags = (removeUnknownConfigureFlags o.configureFlags) ++ [
          "--no-shared-libs"
          "-host ${o.stdenv.hostPlatform.config}"
          "-target ${o.stdenv.targetPlatform.config}"
        ];
      });
    };

in {
  stdenv = foldl (flip id) super.stdenv staticAdapters;
  gcc49Stdenv = foldl (flip id) super.gcc49Stdenv staticAdapters;
  gcc6Stdenv = foldl (flip id) super.gcc6Stdenv staticAdapters;
  gcc7Stdenv = foldl (flip id) super.gcc7Stdenv staticAdapters;
  gcc8Stdenv = foldl (flip id) super.gcc8Stdenv staticAdapters;
  gcc9Stdenv = foldl (flip id) super.gcc9Stdenv staticAdapters;
  clangStdenv = foldl (flip id) super.clangStdenv staticAdapters;
  libcxxStdenv = foldl (flip id) super.libcxxStdenv staticAdapters;

  haskell = super.haskell // {
    packageOverrides = composeExtensions
      (super.haskell.packageOverrides or (_: _: {}))
      haskellStaticAdapter;
  };

  nghttp2 = super.nghttp2.override {
    enableApp = false;
  };

  ncurses = super.ncurses.override {
    enableStatic = true;
  };
  libxml2 = super.libxml2.override ({
    enableShared = false;
    enableStatic = true;
  } // optionalAttrs super.stdenv.hostPlatform.isDarwin {
    pythonSupport = false;
  });
  zlib = super.zlib.override {
    static = true;
    shared = false;
    splitStaticOutput = false;

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
  libiberty = super.libiberty.override {
    staticBuild = true;
  };
  libpfm = super.libpfm.override {
    enableShared = false;
  };
  ipmitool = super.ipmitool.override {
    static = true;
  };
  neon = super.neon.override {
    static = true;
    shared = false;
  };
  fmt = super.fmt.override {
    enableShared = false;
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
  openblas = super.openblas.override {
    enableStatic = true;
    enableShared = false;
  };
  mkl = super.mkl.override { enableStatic = true; };
  nix = super.nix.override { enableStatic = true; };
  openssl = (super.openssl_1_1.override { static = true; }).overrideAttrs (o: {
    # OpenSSL doesn't like the `--enable-static` / `--disable-shared` flags.
    configureFlags = (removeUnknownConfigureFlags o.configureFlags);
  });
  arrow-cpp = super.arrow-cpp.override {
    enableShared = false;
  };
  boost = super.boost.override {
    enableStatic = true;
    enableShared = false;

    # Don’t use new stdenv for boost because it doesn’t like the
    # --disable-shared flag
    stdenv = super.stdenv;
  };
  thrift = super.thrift.override {
    static = true;
    twisted = null;
  };
  gmp = super.gmp.override {
    withStatic = true;
  };
  gflags = super.gflags.override {
    enableShared = false;
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
  woff2 = super.woff2.override {
    static = true;
  };
  snappy = super.snappy.override {
    static = true;
  };
  lz4 = super.lz4.override {
    enableShared = false;
    enableStatic = true;
  };
  libressl = super.libressl.override {
    buildShared = false;
  };
  libjpeg_turbo = super.libjpeg_turbo.override {
    enableStatic = true;
    enableShared = false;
  };

  darwin = super.darwin // {
    libiconv = super.darwin.libiconv.override {
      enableShared = false;
      enableStatic = true;
    };
  };

  kmod = super.kmod.override {
    withStatic = true;
  };

  curl = super.curl.override {
    # a very sad story: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=439039
    gssSupport = false;
  };

  e2fsprogs = super.e2fsprogs.override {
    shared = false;
  };

  brotli = super.brotli.override {
    staticOnly = true;
  };

  zstd = super.zstd.override {
    static = true;
  };

  llvmPackages_8 = super.llvmPackages_8 // {
    libraries = super.llvmPackages_8.libraries // rec {
      libcxxabi = super.llvmPackages_8.libraries.libcxxabi.override {
        enableShared = false;
      };
      libcxx = super.llvmPackages_8.libraries.libcxx.override {
        enableShared = false;
        inherit libcxxabi;
      };
      libunwind = super.llvmPackages_8.libraries.libunwind.override {
        enableShared = false;
      };
    };
  };

  ocaml-ng = self.lib.mapAttrs (_: set:
    if set ? overrideScope' then set.overrideScope' ocamlStaticAdapter else set
  ) super.ocaml-ng;

  python27 = super.python27.override { static = true; };
  python35 = super.python35.override { static = true; };
  python36 = super.python36.override { static = true; };
  python37 = super.python37.override { static = true; };
  python38 = super.python38.override { static = true; };
  python39 = super.python39.override { static = true; };
  python3Minimal = super.python3Minimal.override { static = true; };


  libev = super.libev.override { static = true; };

  libexecinfo = super.libexecinfo.override { enableShared = false; };

  xorg = super.xorg.overrideScope' (xorgself: xorgsuper: {
    libX11 = xorgsuper.libX11.overrideAttrs (attrs: {
      depsBuildBuild = attrs.depsBuildBuild ++ [ (self.buildPackages.stdenv.cc.libc.static or null) ];
    });
    xauth = xorgsuper.xauth.overrideAttrs (attrs: {
      # missing transitive dependencies
      preConfigure = attrs.preConfigure or "" + ''
        export NIX_CFLAGS_LINK="$NIX_CFLAGS_LINK -lxcb -lXau -lXdmcp"
      '';
    });
    xdpyinfo = xorgsuper.xdpyinfo.overrideAttrs (attrs: {
      # missing transitive dependencies
      preConfigure = attrs.preConfigure or "" + ''
        export NIX_CFLAGS_LINK="$NIX_CFLAGS_LINK -lXau -lXdmcp"
      '';
    });
    libxcb = xorgsuper.libxcb.overrideAttrs (attrs: {
      configureFlags = attrs.configureFlags ++ [ "--disable-shared" ];
    });
    libXi= xorgsuper.libXi.overrideAttrs (attrs: {
      configureFlags = attrs.configureFlags ++ [ "--disable-shared" ];
    });
  });
}
