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
                      + optionalString (stdenv_.cc.isGNU or false) " -static-libgcc";
      nativeBuildInputs = (args.nativeBuildInputs or []) ++ [ (makeSetupHook {
        substitutions = {
          libsystem = "${stdenv.cc.libc}/lib/libSystem.B.dylib";
        };
      } ../stdenv/darwin/portable-libsystem.sh) ];
    });
  };

  staticAdapters =
    optional super.stdenv.hostPlatform.isDarwin makeStaticDarwin

    ++ [ makeStaticLibraries propagateBuildInputs ]

    # Apple does not provide a static version of libSystem or crt0.o
    # So we can’t build static binaries without extensive hacks.
    ++ optional (!super.stdenv.hostPlatform.isDarwin) makeStaticBinaries

    # Glibc doesn’t come with static runtimes by default.
    # ++ optional (super.stdenv.hostPlatform.libc == "glibc") ((flip overrideInStdenv) [ self.stdenv.glibc.static ])
  ;

  ocamlFixPackage = b:
    b.overrideAttrs (o: {
      configurePlatforms = [ ];
      dontAddStaticConfigureFlags = true;
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
        dontAddStaticConfigureFlags = true;
        configureFlags = [
          "--no-shared-libs"
          "-host ${o.stdenv.hostPlatform.config}"
          "-target ${o.stdenv.targetPlatform.config}"
        ];
      });
    };

in rec {
  stdenv = foldl (flip id) super.stdenv staticAdapters;

  avahi = super.avahi.overrideAttrs (old: {
    buildInputs = (old.buildInputs or []) ++ [ super.musl ];
    nativeBuildInputs = (old.nativeBuildInputs or []) ++
      [ super.autoreconfHook ];
    postPatch = (old.postPatch or "") + ''
      substituteInPlace common/acx_pthread.m4 \
        --replace '-shared -fPIC ' ""
      substituteInPlace avahi-daemon/Makefile.am \
        --replace 'install-data-local:' "disabled:"
    '';
  });

  boost = super.boost.override {
    # Don’t use new stdenv for boost because it doesn’t like the
    # --disable-shared flag
    stdenv = super.stdenv;
  };

  curl = super.curl.override {
    # brotli doesn't build static (Mar. 2021)
    brotliSupport = false;
    # disable gss becuase of: undefined reference to `k5_bcmp'
    gssSupport = false;
  };

  dconf = super.dconf.overrideAttrs (old: {
    NIX_MESON_DEPENDENCY_STATIC = true;
    nativeBuildInputs = (old.nativeBuildInputs or []) ++ [ super.mesonShlibsToStaticHook ];
  });

  glib = super.glib.overrideAttrs (old: {
    NIX_MESON_DEPENDENCY_STATIC = true;
  });

  json-glib = super.json-glib.overrideAttrs (old: {
    NIX_MESON_DEPENDENCY_STATIC = true;
  });

  libselinux = (super.libselinux.override {
    fts = super.musl-fts;
    enablePython = false;
  }).overrideAttrs (old: {
    patches = (old.patches or []) ++ [
      # Patch to disable shared libraries, a cleaner way
      # would be to fork this to use meson which is much
      # easier to tweak for static builds using NIX_MESON_DEPENDENCY_STATIC
      # and/or the mesonShlibsToStaticHook
      ../os-specific/linux/libselinux/fix-static-build.patch
    ];
  });

  ocaml-ng = self.lib.mapAttrs (_: set:
    if set ? overrideScope' then set.overrideScope' ocamlStaticAdapter else set
  ) super.ocaml-ng;

  p11-kit = super.p11-kit.overrideAttrs (old: {
    postPatch = (old.postPatch or "") + ''
      sed -i '/install_data(pkcs11_conf_example/,+1d' p11-kit/meson.build
    '';
  });

  perl = super.perl.override {
    # Don’t use new stdenv zlib because
    # it doesn’t like the --disable-shared flag
    stdenv = super.stdenv;
  };

  shared-mime-info = super.shared-mime-info.overrideAttrs (old: {
    NIX_MESON_DEPENDENCY_STATIC = true;
    buildInputs = (old.buildInputs or []) ++ [ zlib ];
  });

  zlib = super.zlib.override {
    # Don’t use new stdenv zlib because
    # it doesn’t like the --disable-shared flag
    stdenv = super.stdenv;
  };

  wayland = super.wayland.overrideAttrs (old: {
    NIX_MESON_DEPENDENCY_STATIC = true;
    postPatch = (old.postPatch or "") + ''
      substituteInPlace meson.build \
        --replace "subdir('tests')" ""
    '';
  });
}
