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
  inherit (super.lib) foldl optional flip id composeExtensions optionalAttrs optionalString;
  inherit (super) makeSetupHook;

  # Best effort static binaries. Will still be linked to libSystem,
  # but more portable than Nix store binaries.
  makeStaticDarwin = stdenv_: let stdenv = stdenv_.override {
    # extraBuildInputs are dropped in cross.nix, but darwin still needs them
    extraBuildInputs = [ self.buildPackages.darwin.CF ];
  }; in stdenv // {
    mkDerivation = args: stdenv.mkDerivation (args // {
      NIX_CFLAGS_LINK = toString (args.NIX_CFLAGS_LINK or "")
                      + optionalString stdenv.cc.isGNU " -static-libgcc";
      nativeBuildInputs = (args.nativeBuildInputs or []) ++ [ (makeSetupHook {
        substitutions = {
          libsystem = "${stdenv.cc.libc}/lib/libSystem.B.dylib";
        };
      } ../stdenv/darwin/portable-libsystem.sh) ];
    });
  };

  staticAdapters =
    # makeStaticDarwin must go first so that the extraBuildInputs
    # override does not recreate mkDerivation, removing subsequent
    # adapters.
    optional super.stdenv.hostPlatform.isDarwin makeStaticDarwin

    ++ [ makeStaticLibraries propagateBuildInputs ]

    # Apple does not provide a static version of libSystem or crt0.o
    # So we can’t build static binaries without extensive hacks.
    ++ optional (!super.stdenv.hostPlatform.isDarwin) makeStaticBinaries

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

  zlib = super.zlib.override {
    # Don’t use new stdenv zlib because
    # it doesn’t like the --disable-shared flag
    stdenv = super.stdenv;
  };
  gifsicle = super.gifsicle.override {
    static = true;
  };
  openssl = super.openssl_1_1.overrideAttrs (o: {
    # OpenSSL doesn't like the `--enable-static` / `--disable-shared` flags.
    configureFlags = (removeUnknownConfigureFlags o.configureFlags);
  });
  boost = super.boost.override {
    # Don’t use new stdenv for boost because it doesn’t like the
    # --disable-shared flag
    stdenv = super.stdenv;
  };
  cdo = super.cdo.override {
    enable_all_static = true;
  };
  gsm = super.gsm.override {
    staticSupport = true;
  };
  crc32c = super.crc32c.override {
    staticOnly = true;
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
  libressl = super.libressl.override {
    buildShared = false;
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

  ocaml-ng = self.lib.mapAttrs (_: set:
    if set ? overrideScope' then set.overrideScope' ocamlStaticAdapter else set
  ) super.ocaml-ng;

  python27 = super.python27.override { static = true; };
  python36 = super.python36.override { static = true; };
  python37 = super.python37.override { static = true; };
  python38 = super.python38.override { static = true; };
  python39 = super.python39.override { static = true; };
  python3Minimal = super.python3Minimal.override { static = true; };

  # Note: -static doesn’t work on darwin
  libev = super.libev.override { static = !super.stdenv.hostPlatform.isDarwin; };

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
