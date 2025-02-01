let

  generic =
      # dependencies
      { stdenv, lib, fetchurl, fetchpatch, makeWrapper
      , glibc, zlib, readline, openssl, icu, lz4, zstd, systemdLibs, libossp_uuid
      , pkg-config, libxml2, tzdata, libkrb5, substituteAll, darwin
      , linux-pam
      , removeReferencesTo

      # This is important to obtain a version of `libpq` that does not depend on systemd.
      , systemdSupport ? lib.meta.availableOn stdenv.hostPlatform systemdLibs && !stdenv.hostPlatform.isStatic
      , enableSystemd ? null
      , gssSupport ? with stdenv.hostPlatform; !isWindows && !isStatic

      # for postgresql.pkgs
      , self, newScope, buildEnv

      # source specification
      , version, hash, muslPatches ? {}

      # for tests
      , testers

      # JIT
      , jitSupport
      , nukeReferences, llvmPackages, overrideCC

      # PL/Python
      , pythonSupport ? false
      , python3

      # detection of crypt fails when using llvm stdenv, so we add it manually
      # for <13 (where it got removed: https://github.com/postgres/postgres/commit/c45643d618e35ec2fe91438df15abd4f3c0d85ca)
      , libxcrypt
    } @args:
  let
    atLeast = lib.versionAtLeast version;
    olderThan = lib.versionOlder version;
    lz4Enabled = atLeast "14";
    zstdEnabled = atLeast "15";

    dlSuffix = if olderThan "16" then ".so" else stdenv.hostPlatform.extensions.sharedLibrary;

    systemdSupport' = if enableSystemd == null then systemdSupport else (lib.warn "postgresql: argument enableSystemd is deprecated, please use systemdSupport instead." enableSystemd);

    pname = "postgresql";

    stdenv' =
      if jitSupport then
        overrideCC llvmPackages.stdenv (llvmPackages.stdenv.cc.override {
          # LLVM bintools are not used by default, but are needed to make -flto work below.
          bintools = llvmPackages.bintools;
        })
      else
        stdenv;
  in stdenv'.mkDerivation (finalAttrs: {
    inherit version;
    pname = pname + lib.optionalString jitSupport "-jit";

    src = fetchurl {
      url = "mirror://postgresql/source/v${version}/${pname}-${version}.tar.bz2";
      inherit hash;
    };

    __structuredAttrs = true;

    hardeningEnable = lib.optionals (!stdenv'.cc.isClang) [ "pie" ];

    outputs = [ "out" "dev" "doc" "lib" "man" ];
    outputChecks.out = {
      disallowedReferences = [ "dev" "doc" "man" ];
      disallowedRequisites = [
        stdenv'.cc
      ] ++ (
        map lib.getDev (builtins.filter (drv: drv ? "dev") finalAttrs.buildInputs)
      ) ++ lib.optionals jitSupport [
        llvmPackages.llvm.out
      ];
    };
    outputChecks.lib = {
      disallowedReferences = [ "out" "dev" "doc" "man" ];
      disallowedRequisites = [
        stdenv'.cc
      ] ++ (
        map lib.getDev (builtins.filter (drv: drv ? "dev") finalAttrs.buildInputs)
      ) ++ lib.optionals jitSupport [
        llvmPackages.llvm.out
      ];
    };

    buildInputs = [
      zlib
      readline
      openssl
      (libxml2.override {enableHttp = true;})
      icu
    ]
      ++ lib.optionals (olderThan "13") [ libxcrypt ]
      ++ lib.optionals jitSupport [ llvmPackages.llvm ]
      ++ lib.optionals lz4Enabled [ lz4 ]
      ++ lib.optionals zstdEnabled [ zstd ]
      ++ lib.optionals systemdSupport' [ systemdLibs ]
      ++ lib.optionals pythonSupport [ python3 ]
      ++ lib.optionals gssSupport [ libkrb5 ]
      ++ lib.optionals stdenv'.isLinux [ linux-pam ]
      ++ lib.optionals (!stdenv'.isDarwin) [ libossp_uuid ];

    nativeBuildInputs = [
      makeWrapper
      pkg-config
      removeReferencesTo
    ]
      ++ lib.optionals jitSupport [ llvmPackages.llvm.dev nukeReferences ];

    enableParallelBuilding = true;

    separateDebugInfo = true;

    buildFlags = [ "world" ];

    # libpgcommon.a and libpgport.a contain all paths returned by pg_config and are linked
    # into all binaries. However, almost no binaries actually use those paths. The following
    # flags will remove unused sections from all shared libraries and binaries - including
    # those paths. This avoids a lot of circular dependency problems with different outputs,
    # and allows splitting them cleanly.
    env.CFLAGS = "-fdata-sections -ffunction-sections"
      + (if stdenv'.cc.isClang then " -flto" else " -fmerge-constants -Wl,--gc-sections")
      + lib.optionalString (stdenv'.isDarwin && jitSupport) " -fuse-ld=lld"
      # Makes cross-compiling work when xml2-config can't be executed on the host.
      # Fixed upstream in https://github.com/postgres/postgres/commit/0bc8cebdb889368abdf224aeac8bc197fe4c9ae6
      + lib.optionalString (olderThan "13") " -I${libxml2.dev}/include/libxml2";

    configureFlags = [
      "--with-openssl"
      "--with-libxml"
      "--with-icu"
      "--sysconfdir=/etc"
      "--with-system-tzdata=${tzdata}/share/zoneinfo"
      "--enable-debug"
      (lib.optionalString systemdSupport' "--with-systemd")
      (if stdenv'.isDarwin then "--with-uuid=e2fs" else "--with-ossp-uuid")
    ] ++ lib.optionals lz4Enabled [ "--with-lz4" ]
      ++ lib.optionals zstdEnabled [ "--with-zstd" ]
      ++ lib.optionals gssSupport [ "--with-gssapi" ]
      ++ lib.optionals pythonSupport [ "--with-python" ]
      ++ lib.optionals jitSupport [ "--with-llvm" ]
      ++ lib.optionals stdenv'.isLinux [ "--with-pam" ]
      # This could be removed once the upstream issue is resolved:
      # https://postgr.es/m/flat/427c7c25-e8e1-4fc5-a1fb-01ceff185e5b%40technowledgy.de
      ++ lib.optionals (stdenv'.isDarwin && atLeast "16") [ "LDFLAGS_EX_BE=-Wl,-export_dynamic" ];

    patches = [
      (if atLeast "16" then ./patches/relative-to-symlinks-16+.patch else ./patches/relative-to-symlinks.patch)
      (if atLeast "15" then ./patches/empty-pg-config-view-15+.patch else ./patches/empty-pg-config-view.patch)
      ./patches/less-is-more.patch
      ./patches/paths-for-split-outputs.patch
      ./patches/paths-with-postgresql-suffix.patch

      (substituteAll {
        src = ./patches/locale-binary-path.patch;
        locale = "${if stdenv.isDarwin then darwin.adv_cmds else lib.getBin stdenv.cc.libc}/bin/locale";
      })
    ] ++ lib.optionals stdenv'.hostPlatform.isMusl (
      # Using fetchurl instead of fetchpatch on purpose: https://github.com/NixOS/nixpkgs/issues/240141
      map fetchurl (lib.attrValues muslPatches)
    ) ++ lib.optionals stdenv'.isLinux  [
      (if atLeast "13" then ./patches/socketdir-in-run-13+.patch else ./patches/socketdir-in-run.patch)
    ] ++ lib.optionals (stdenv'.isDarwin && olderThan "16") [
      ./patches/export-dynamic-darwin-15-.patch
    ];

    installTargets = [ "install-world" ];

    postPatch = ''
      substituteInPlace "src/Makefile.global.in" --subst-var out
      # Hardcode the path to pgxs so pg_config returns the path in $dev
      substituteInPlace "src/common/config_info.c" --subst-var dev
    '';

    postInstall =
      ''
        moveToOutput "bin/ecpg" "$dev"
        moveToOutput "lib/pgxs" "$dev"

        # Pretend pg_config is located in $out/bin to return correct paths, but
        # actually have it in -dev to avoid pulling in all other outputs.
        moveToOutput "bin/pg_config" "$dev"
        # To prevent a "pg_config: could not find own program executable" error, we fake
        # pg_config in the default output.
        cat << EOF > "$out/bin/pg_config" && chmod +x "$out/bin/pg_config"
        #!${stdenv'.shell}
        echo The real pg_config can be found in the -dev output.
        exit 1
        EOF
        wrapProgram "$dev/bin/pg_config" --argv0 "$out/bin/pg_config"

        # postgres exposes external symbols get_pkginclude_path and similar. Those
        # can't be stripped away by --gc-sections/LTO, because they could theoretically
        # be used by dynamically loaded modules / extensions. To avoid circular dependencies,
        # references to -dev, -doc and -man are removed here. References to -lib must be kept,
        # because there is a realistic use-case for extensions to locate the /lib directory to
        # load other shared modules.
        remove-references-to -t "$dev" -t "$doc" -t "$man" "$out/bin/postgres"

        if [ -z "''${dontDisableStatic:-}" ]; then
          # Remove static libraries in case dynamic are available.
          for i in $lib/lib/*.a; do
            name="$(basename "$i")"
            ext="${stdenv'.hostPlatform.extensions.sharedLibrary}"
            if [ -e "$lib/lib/''${name%.a}$ext" ] || [ -e "''${i%.a}$ext" ]; then
              rm "$i"
            fi
          done
        fi
        # The remaining static libraries are libpgcommon.a, libpgport.a and related.
        # Those are only used when building e.g. extensions, so go to $dev.
        moveToOutput "lib/*.a" "$dev"
      '' + lib.optionalString jitSupport ''
        # In the case of JIT support, prevent useless dependencies on header files
        find "$out/lib" -iname '*.bc' -type f -exec nuke-refs '{}' +

        # Stop lib depending on the -dev output of llvm
        remove-references-to -t ${llvmPackages.llvm.dev} "$out/lib/llvmjit${dlSuffix}"
      '';

    postFixup = lib.optionalString stdenv'.hostPlatform.isGnu
      ''
        # initdb needs access to "locale" command from glibc.
        wrapProgram $out/bin/initdb --prefix PATH ":" ${glibc.bin}/bin
      '';

    doCheck = !stdenv'.isDarwin;
    # autodetection doesn't seem to able to find this, but it's there.
    checkTarget = "check";

    passthru = let
      this = self.callPackage generic args;
      jitToggle = this.override {
        jitSupport = !jitSupport;
      };
    in
    {
      inherit dlSuffix;

      psqlSchema = lib.versions.major version;

      withJIT = if jitSupport then this else jitToggle;
      withoutJIT = if jitSupport then jitToggle else this;

      pkgs = let
        scope = {
          inherit jitSupport;
          inherit (llvmPackages) llvm;
          postgresql = this;
          stdenv = stdenv';
        };
        newSelf = self // scope;
        newSuper = { callPackage = newScope (scope // this.pkgs); };
      in import ./ext newSelf newSuper;

      withPackages = postgresqlWithPackages {
                       inherit buildEnv;
                       postgresql = this;
                     }
                     this.pkgs;

      tests = {
        postgresql-wal-receiver = import ../../../../nixos/tests/postgresql-wal-receiver.nix {
          inherit (stdenv) system;
          pkgs = self;
          package = this;
        };
        pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
      } // lib.optionalAttrs jitSupport {
        postgresql-jit = import ../../../../nixos/tests/postgresql-jit.nix {
          inherit (stdenv) system;
          pkgs = self;
          package = this;
        };
      };
    };

    meta = with lib; {
      homepage    = "https://www.postgresql.org";
      description = "Powerful, open source object-relational database system";
      license     = licenses.postgresql;
      changelog   = "https://www.postgresql.org/docs/release/${finalAttrs.version}/";
      maintainers = with maintainers; [ thoughtpolice danbst globin ivan ma27 wolfgangwalther ];
      pkgConfigModules = [ "libecpg" "libecpg_compat" "libpgtypes" "libpq" ];
      platforms   = platforms.unix;

      # JIT support doesn't work with cross-compilation. It is attempted to build LLVM-bytecode
      # (`%.bc` is the corresponding `make(1)`-rule) for each sub-directory in `backend/` for
      # the JIT apparently, but with a $(CLANG) that can produce binaries for the build, not the
      # host-platform.
      #
      # I managed to get a cross-build with JIT support working with
      # `depsBuildBuild = [ llvmPackages.clang ] ++ buildInputs`, but considering that the
      # resulting LLVM IR isn't platform-independent this doesn't give you much.
      # In fact, I tried to test the result in a VM-test, but as soon as JIT was used to optimize
      # a query, postgres would coredump with `Illegal instruction`.
      broken = jitSupport && !stdenv.hostPlatform.canExecute stdenv.buildPlatform;
    };
  });

  postgresqlWithPackages = { postgresql, buildEnv }: pkgs: f: buildEnv {
    name = "postgresql-and-plugins-${postgresql.version}";
    paths = f pkgs ++ [
        postgresql
        postgresql.man   # in case user installs this into environment
    ];

    pathsToLink = ["/"];

    passthru.version = postgresql.version;
    passthru.psqlSchema = postgresql.psqlSchema;
  };

in
# passed by <major>.nix
versionArgs:
# passed by default.nix
{ self, ... } @defaultArgs:
self.callPackage generic (defaultArgs // versionArgs)
