let

  generic =
    # utils
    {
      stdenv,
      fetchFromGitHub,
      fetchurl,
      lib,
      replaceVars,
      writeShellScriptBin,

      # source specification
      hash,
      muslPatches ? { },
      rev,
      version,

      # runtime dependencies
      darwin,
      freebsd,
      glibc,
      libuuid,
      libxml2,
      lz4,
      openssl,
      readline,
      tzdata,
      zlib,
      zstd,

      # build dependencies
      bison,
      docbook-xsl-nons,
      docbook_xml_dtd_45,
      flex,
      libxslt,
      makeBinaryWrapper,
      pkg-config,
      removeReferencesTo,

      # passthru
      buildEnv,
      buildPackages,
      newScope,
      nixosTests,
      postgresqlTestHook,
      self,
      stdenvNoCC,
      testers,

      # Block size
      # Changing the block size will break on-disk database compatibility. See:
      # https://www.postgresql.org/docs/current/install-make.html#CONFIGURE-OPTION-WITH-BLOCKSIZE
      withBlocksize ? null,
      withWalBlocksize ? null,

      # bonjour
      bonjourSupport ? false,

      # Curl
      curlSupport ?
        lib.versionAtLeast version "18"
        && lib.meta.availableOn stdenv.hostPlatform curl
        # Building statically fails with:
        # configure: error: library 'curl' does not provide curl_multi_init
        # https://www.postgresql.org/message-id/487dacec-6d8d-46c0-a36f-d5b8c81a56f1%40technowledgy.de
        && !stdenv.hostPlatform.isStatic,
      curl,

      # GSSAPI
      gssSupport ? with stdenv.hostPlatform; !isWindows && !isStatic,
      libkrb5,

      # icu
      # Building with icu in pkgsStatic gives tons of "undefined reference" errors like this:
      #   /nix/store/452lkaak37d3mzzn3p9ak7aa3wzhdqaj-icu4c-74.2-x86_64-unknown-linux-musl/lib/libicuuc.a(chariter.ao):
      #    (.data.rel.ro._ZTIN6icu_7417CharacterIteratorE[_ZTIN6icu_7417CharacterIteratorE]+0x0):
      #    undefined reference to `vtable for __cxxabiv1::__si_class_type_info'
      icuSupport ? !stdenv.hostPlatform.isStatic,
      icu,

      # JIT
      jitSupport ?
        stdenv.hostPlatform.canExecute stdenv.buildPlatform
        # Building with JIT in pkgsStatic fails like this:
        #   fatal error: 'stdio.h' file not found
        && !stdenv.hostPlatform.isStatic,
      llvmPackages,
      nukeReferences,
      overrideCC,

      # LDAP
      ldapSupport ? false,
      openldap,

      # NLS
      nlsSupport ? false,
      gettext,

      # NUMA
      numaSupport ? lib.versionAtLeast version "18" && lib.meta.availableOn stdenv.hostPlatform numactl,
      numactl,

      # PAM
      pamSupport ?
        lib.meta.availableOn stdenv.hostPlatform linux-pam
        # Building with linux-pam in pkgsStatic gives a few "undefined reference" errors like this:
        #   /nix/store/3s55icpsbc36sgn7sa8q3qq4z6al6rlr-linux-pam-static-x86_64-unknown-linux-musl-1.6.1/lib/libpam.a(pam_audit.o):
        #     in function `pam_modutil_audit_write':(.text+0x571):
        #     undefined reference to `audit_close'
        && !stdenv.hostPlatform.isStatic,
      linux-pam,

      # PL/Perl
      perlSupport ?
        lib.meta.availableOn stdenv.hostPlatform perl
        # Building with perl in pkgsStatic gives this error:
        #   configure: error: cannot build PL/Perl because libperl is not a shared library
        && !stdenv.hostPlatform.isStatic
        # configure tries to call the perl executable for the version
        && stdenv.buildPlatform.canExecute stdenv.hostPlatform,
      perl,

      # PL/Python
      pythonSupport ?
        lib.meta.availableOn stdenv.hostPlatform python3
        # Building with python in pkgsStatic gives this error:
        #  checking how to link an embedded Python application... configure: error: could not find shared library for Python
        && !stdenv.hostPlatform.isStatic
        # configure tries to call the python executable
        && stdenv.buildPlatform.canExecute stdenv.hostPlatform,
      python3,

      # PL/Tcl
      tclSupport ?
        lib.meta.availableOn stdenv.hostPlatform tcl
        # tcl is broken in pkgsStatic
        && !stdenv.hostPlatform.isStatic
        # configure fails with:
        #   configure: error: file 'tclConfig.sh' is required for Tcl
        && stdenv.buildPlatform.canExecute stdenv.hostPlatform,
      tcl,

      # SELinux
      selinuxSupport ? false,
      libselinux,

      # Systemd
      systemdSupport ? lib.meta.availableOn stdenv.hostPlatform systemdLibs,
      systemdLibs,

      # Uring
      uringSupport ? lib.versionAtLeast version "18" && lib.meta.availableOn stdenv.hostPlatform liburing,
      liburing,
    }@args:
    let
      atLeast = lib.versionAtLeast version;
      olderThan = lib.versionOlder version;
      lz4Enabled = atLeast "14";
      zstdEnabled = atLeast "15";

      dlSuffix = if olderThan "16" then ".so" else stdenv.hostPlatform.extensions.sharedLibrary;

      stdenv' =
        if !stdenv.cc.isClang then
          overrideCC llvmPackages.stdenv (
            llvmPackages.stdenv.cc.override {
              # LLVM bintools are not used by default, but are needed to make -flto work below.
              bintools = llvmPackages.bintools;
            }
          )
        else
          stdenv;
    in
    stdenv'.mkDerivation (finalAttrs: {
      inherit version;
      pname = "postgresql";

      src = fetchFromGitHub {
        owner = "postgres";
        repo = "postgres";
        # rev, not tag, on purpose: allows updating when new versions
        # are "stamped" a few days before release (tag).
        inherit hash rev;
      };

      __structuredAttrs = true;

      outputs = [
        "out"
        "dev"
        "doc"
        "lib"
        "man"
      ]
      ++ lib.optionals jitSupport [ "jit" ]
      ++ lib.optionals perlSupport [ "plperl" ]
      ++ lib.optionals pythonSupport [ "plpython3" ]
      ++ lib.optionals tclSupport [ "pltcl" ];

      outputChecks = {
        out = {
          disallowedReferences = [
            "dev"
            "doc"
            "man"
          ]
          ++ lib.optionals jitSupport [ "jit" ];
          disallowedRequisites = [
            stdenv'.cc
            llvmPackages.llvm.out
            llvmPackages.llvm.lib
          ]
          ++ (map lib.getDev (builtins.filter (drv: drv ? "dev") finalAttrs.buildInputs));
        };

        lib = {
          disallowedReferences = [
            "out"
            "dev"
            "doc"
            "man"
          ]
          ++ lib.optionals jitSupport [ "jit" ];
          disallowedRequisites = [
            stdenv'.cc
            llvmPackages.llvm.out
            llvmPackages.llvm.lib
          ]
          ++ (map lib.getDev (builtins.filter (drv: drv ? "dev") finalAttrs.buildInputs));
        };

        doc = {
          disallowedReferences = [
            "out"
            "dev"
            "man"
          ]
          ++ lib.optionals jitSupport [ "jit" ];
        };

        man = {
          disallowedReferences = [
            "out"
            "dev"
            "doc"
          ]
          ++ lib.optionals jitSupport [ "jit" ];
        };
      }
      // lib.optionalAttrs jitSupport {
        jit = {
          disallowedReferences = [
            "dev"
            "doc"
            "man"
          ];
          disallowedRequisites = [
            stdenv'.cc
            llvmPackages.llvm.out
          ]
          ++ (map lib.getDev (builtins.filter (drv: drv ? "dev") finalAttrs.buildInputs));
        };
      };

      strictDeps = true;

      buildInputs = [
        zlib
        readline
        openssl
        libxml2
        libuuid
      ]
      ++ lib.optionals icuSupport [ icu ]
      ++ lib.optionals jitSupport [ llvmPackages.llvm ]
      ++ lib.optionals lz4Enabled [ lz4 ]
      ++ lib.optionals zstdEnabled [ zstd ]
      ++ lib.optionals systemdSupport [ systemdLibs ]
      ++ lib.optionals uringSupport [ liburing ]
      ++ lib.optionals curlSupport [ curl ]
      ++ lib.optionals numaSupport [ numactl ]
      ++ lib.optionals gssSupport [ libkrb5 ]
      ++ lib.optionals pamSupport [ linux-pam ]
      ++ lib.optionals perlSupport [ perl ]
      ++ lib.optionals ldapSupport [ openldap ]
      ++ lib.optionals selinuxSupport [ libselinux ]
      ++ lib.optionals nlsSupport [ gettext ];

      nativeBuildInputs = [
        bison
        docbook-xsl-nons
        docbook_xml_dtd_45
        flex
        libxml2
        libxslt
        makeBinaryWrapper
        perl
        pkg-config
        removeReferencesTo
      ]
      ++ lib.optionals jitSupport [
        llvmPackages.llvm.dev
        nukeReferences
      ];

      enableParallelBuilding = true;

      separateDebugInfo = true;

      buildFlags = [ "world" ];

      env = {
        # libpgcommon.a and libpgport.a contain all paths returned by pg_config and are linked
        # into all binaries. However, almost no binaries actually use those paths. The following
        # flags will remove unused sections from all shared libraries and binaries - including
        # those paths. This avoids a lot of circular dependency problems with different outputs,
        # and allows splitting them cleanly.
        CFLAGS = "-fdata-sections -ffunction-sections -flto";

        # This flag was introduced upstream in:
        # https://github.com/postgres/postgres/commit/b6c7cfac88c47a9194d76f3d074129da3c46545a
        # It causes errors when linking against libpq.a in pkgsStatic:
        #   undefined reference to `pg_encoding_to_char'
        # Unsetting the flag fixes it. The upstream reasoning to introduce it is about the risk
        # to have initdb load a libpq.so from a different major version and how to avoid that.
        # This doesn't apply to us with Nix.
        NIX_CFLAGS_COMPILE = "-UUSE_PRIVATE_ENCODING_FUNCS";
      }
      // lib.optionalAttrs perlSupport { PERL = lib.getExe perl; }
      // lib.optionalAttrs pythonSupport { PYTHON = lib.getExe python3; }
      // lib.optionalAttrs tclSupport { TCLSH = "${lib.getBin tcl}/bin/tclsh"; };

      configureFlags =
        let
          inherit (lib) withFeature;
        in
        [
          "--with-openssl"
          "--with-libxml"
          (withFeature icuSupport "icu")
          "--sysconfdir=/etc"
          "--with-system-tzdata=${tzdata}/share/zoneinfo"
          "--enable-debug"
          (lib.optionalString systemdSupport "--with-systemd")
          (if stdenv.hostPlatform.isFreeBSD then "--with-uuid=bsd" else "--with-uuid=e2fs")
          (withFeature perlSupport "perl")
        ]
        ++ lib.optionals (withBlocksize != null) [ "--with-blocksize=${toString withBlocksize}" ]
        ++ lib.optionals (withWalBlocksize != null) [ "--with-wal-blocksize=${toString withWalBlocksize}" ]
        ++ lib.optionals lz4Enabled [ "--with-lz4" ]
        ++ lib.optionals zstdEnabled [ "--with-zstd" ]
        ++ lib.optionals uringSupport [ "--with-liburing" ]
        ++ lib.optionals curlSupport [ "--with-libcurl" ]
        ++ lib.optionals numaSupport [ "--with-libnuma" ]
        ++ lib.optionals gssSupport [ "--with-gssapi" ]
        ++ lib.optionals pythonSupport [ "--with-python" ]
        ++ lib.optionals jitSupport [ "--with-llvm" ]
        ++ lib.optionals pamSupport [ "--with-pam" ]
        # This can be removed once v17 is removed. v18+ ships with it.
        ++ lib.optionals (stdenv'.hostPlatform.isDarwin && atLeast "16" && olderThan "18") [
          "LDFLAGS_EX_BE=-Wl,-export_dynamic"
        ]
        # some version of this flag is required in all cross configurations
        # since it cannot be automatically detected
        ++
          lib.optionals
            (
              (!stdenv'.hostPlatform.isDarwin)
              && (!(stdenv'.buildPlatform.canExecute stdenv.hostPlatform))
              && atLeast "16"
            )
            [
              "LDFLAGS_EX_BE=-Wl,--export-dynamic"
            ]
        ++ lib.optionals ldapSupport [ "--with-ldap" ]
        ++ lib.optionals tclSupport [ "--with-tcl" ]
        ++ lib.optionals selinuxSupport [ "--with-selinux" ]
        ++ lib.optionals nlsSupport [ "--enable-nls" ]
        ++ lib.optionals bonjourSupport [ "--with-bonjour" ];

      patches = [
        (
          if atLeast "16" then
            ./patches/relative-to-symlinks-16+.patch
          else
            ./patches/relative-to-symlinks.patch
        )
        (
          if atLeast "15" then
            ./patches/empty-pg-config-view-15+.patch
          else
            ./patches/empty-pg-config-view.patch
        )
        ./patches/less-is-more.patch
        ./patches/paths-for-split-outputs.patch
        ./patches/paths-with-postgresql-suffix.patch

        (replaceVars ./patches/locale-binary-path.patch {
          locale = "${
            if stdenv.hostPlatform.isDarwin then
              darwin.adv_cmds
            else if stdenv.hostPlatform.isFreeBSD then
              freebsd.locale
            else
              lib.getBin stdenv.cc.libc
          }/bin/locale";
        })
      ]
      ++ lib.optionals stdenv'.hostPlatform.isMusl (
        # Using fetchurl instead of fetchpatch on purpose: https://github.com/NixOS/nixpkgs/issues/240141
        map fetchurl (lib.attrValues muslPatches)
      )
      ++ lib.optionals stdenv'.hostPlatform.isLinux [
        ./patches/socketdir-in-run-13+.patch
      ]
      ++ lib.optionals (stdenv'.hostPlatform.isDarwin && olderThan "16") [
        ./patches/export-dynamic-darwin-15-.patch
      ];

      installTargets = [ "install-world" ];

      postPatch = ''
        substituteInPlace "src/Makefile.global.in" --subst-var out
        substituteInPlace "src/common/config_info.c" --subst-var dev
        cat ${./pg_config.env.mk} >> src/common/Makefile
      ''
      # This test always fails on hardware with >1 NUMA node: the sysfs
      # dirs providing information about the topology are hidden in the sandbox,
      # so postgres assumes there's only a single node `0`. However,
      # the test checks on which NUMA nodes the allocated pages are which is >1
      # on such hardware. This in turn triggers a safeguard in the view
      # which breaks the test.
      # Manual tests confirm that the testcase behaves properly outside of the
      # Nix sandbox.
      + lib.optionalString (atLeast "18") ''
        substituteInPlace src/test/regress/parallel_schedule \
          --replace-fail numa ""
      ''
      # This check was introduced upstream to prevent calls to "exit" inside libpq.
      # However, this doesn't work reliably with static linking, see this and following:
      # https://postgr.es/m/flat/20210703001639.GB2374652%40rfd.leadboat.com#52584ca4bd3cb9dac376f3158c419f97
      # Thus, disable the check entirely, as it would currently fail with this:
      # > libpq.so.5.17:                  U atexit
      # > libpq.so.5.17:                  U pthread_exit
      # > libpq must not be calling any function which invokes exit
      # Don't mind the fact that this checks libpq.**so** in pkgsStatic - that's correct, since PostgreSQL
      # still needs a shared library internally.
      + lib.optionalString (atLeast "15" && stdenv'.hostPlatform.isStatic) ''
        substituteInPlace src/interfaces/libpq/Makefile \
          --replace-fail "echo 'libpq must not be calling any function which invokes exit'; exit 1;" "echo;"
      '';

      postInstall = ''
        moveToOutput "bin/ecpg" "$dev"
        moveToOutput "lib/pgxs" "$dev"
      ''
      + lib.optionalString (stdenv'.buildPlatform.canExecute stdenv'.hostPlatform) ''
        mkdir -p "$dev/nix-support"
        "$out/bin/pg_config" > "$dev/nix-support/pg_config.expected"
      ''
      + ''
          rm "$out/bin/pg_config"
          make -C src/common pg_config.env
          substituteInPlace src/common/pg_config.env \
            --replace-fail "$out" "@out@" \
            --replace-fail "$man" "@man@"
          install -D src/common/pg_config.env "$dev/nix-support/pg_config.env"

        # postgres exposes external symbols get_pkginclude_path and similar. Those
        # can't be stripped away by --gc-sections/LTO, because they could theoretically
        # be used by dynamically loaded modules / extensions. To avoid circular dependencies,
        # references to -dev, -doc and -man are removed here. References to -lib must be kept,
        # because there is a realistic use-case for extensions to locate the /lib directory to
        # load other shared modules.
        remove-references-to -t "$dev" -t "$doc" -t "$man" "$out/bin/postgres"
      ''
      + lib.optionalString (!stdenv'.hostPlatform.isStatic) ''
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
      ''
      + ''
        # The remaining static libraries are libpgcommon.a, libpgport.a and related.
        # Those are only used when building e.g. extensions, so go to $dev.
        moveToOutput "lib/*.a" "$dev"
      ''
      + lib.optionalString jitSupport ''
        # In the case of JIT support, prevent useless dependencies on header files
        find "$out/lib" -iname '*.bc' -type f -exec nuke-refs '{}' +

        # Stop lib depending on the -dev output of llvm
        remove-references-to -t ${llvmPackages.llvm.dev} "$out/lib/llvmjit${dlSuffix}"

        moveToOutput "lib/bitcode" "$jit"
        moveToOutput "lib/llvmjit*" "$jit"
      ''
      + lib.optionalString stdenv'.hostPlatform.isDarwin ''
        # The darwin specific Makefile for PGXS contains a reference to the postgres
        # binary. Some extensions (here: postgis), which are able to set bindir correctly
        # to their own output for installation, will then fail to find "postgres" during linking.
        substituteInPlace "$dev/lib/pgxs/src/Makefile.port" \
          --replace-fail '-bundle_loader $(bindir)/postgres' "-bundle_loader $out/bin/postgres"
      ''
      + lib.optionalString perlSupport ''
        moveToOutput "lib/*plperl*" "$plperl"
        moveToOutput "share/postgresql/extension/*plperl*" "$plperl"
      ''
      + lib.optionalString pythonSupport ''
        moveToOutput "lib/*plpython3*" "$plpython3"
        moveToOutput "share/postgresql/extension/*plpython3*" "$plpython3"
      ''
      + lib.optionalString tclSupport ''
        moveToOutput "lib/*pltcl*" "$pltcl"
        moveToOutput "share/postgresql/extension/*pltcl*" "$pltcl"
      '';

      postFixup = lib.optionalString stdenv'.hostPlatform.isGnu ''
        # initdb needs access to "locale" command from glibc.
        wrapProgram $out/bin/initdb --prefix PATH ":" ${glibc.bin}/bin
      '';

      # Running tests as "install check" to work around SIP issue on macOS:
      # https://www.postgresql.org/message-id/flat/4D8E1BC5-BBCF-4B19-8226-359201EA8305%40gmail.com
      # Also see <nixpkgs>/doc/stdenv/platform-notes.chapter.md
      doCheck = false;
      doInstallCheck =
        !(stdenv'.hostPlatform.isStatic)
        &&
          # Tests currently can't be run on darwin, because of a Nix bug:
          # https://github.com/NixOS/nix/issues/12548
          # https://git.lix.systems/lix-project/lix/issues/691
          # The error appears as this in the initdb logs:
          #   FATAL:  could not create shared memory segment: Cannot allocate memory
          # Don't let yourself be fooled when trying to remove this condition: Running
          # the tests works fine most of the time. But once the tests (or any package using
          # postgresqlTestHook) fails on the same machine for a few times, enough IPC objects
          # will be stuck around, and any future builds with the tests enabled *will* fail.
          !(stdenv'.hostPlatform.isDarwin)
        &&
          # Regression tests currently fail in pkgsMusl because of a difference in EXPLAIN output.
          !(stdenv'.hostPlatform.isMusl)
        &&
          # Modifying block sizes is expected to break regression tests.
          # https://www.postgresql.org/message-id/E1TJOeZ-000717-Lg%40wrigleys.postgresql.org
          (withBlocksize == null && withWalBlocksize == null);
      installCheckTarget = "check-world";

      passthru =
        let
          this = self.callPackage generic args;
        in
        {
          inherit dlSuffix;

          psqlSchema = lib.versions.major version;

          withJIT = this.withPackages (_: [ this.jit ]);
          withoutJIT = this;

          pkgs =
            let
              scope = {
                inherit
                  jitSupport
                  pythonSupport
                  perlSupport
                  tclSupport
                  ;
                inherit (llvmPackages) llvm;
                postgresql = this;
                stdenv = stdenv';
                postgresqlTestExtension = newSuper.callPackage ./postgresqlTestExtension.nix { };
                postgresqlBuildExtension = newSuper.callPackage ./postgresqlBuildExtension.nix { };
              };
              newSelf = self // scope;
              newSuper = {
                callPackage = newScope (scope // this.pkgs);
              };
            in
            import ./ext.nix newSelf newSuper;

          withPackages = postgresqlWithPackages {
            inherit buildEnv lib makeBinaryWrapper;
            postgresql = this;
          };

          pg_config = buildPackages.callPackage ./pg_config.nix {
            inherit (finalAttrs) finalPackage;
            outputs = {
              out = lib.getOutput "out" finalAttrs.finalPackage;
              man = lib.getOutput "man" finalAttrs.finalPackage;
            };
          };

          tests = {
            postgresql = nixosTests.postgresql.postgresql.passthru.override finalAttrs.finalPackage;
            postgresql-tls-client-cert = nixosTests.postgresql.postgresql-tls-client-cert.passthru.override finalAttrs.finalPackage;
            postgresql-wal-receiver = nixosTests.postgresql.postgresql-wal-receiver.passthru.override finalAttrs.finalPackage;
            pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
          }
          // lib.optionalAttrs jitSupport {
            postgresql-jit = nixosTests.postgresql.postgresql-jit.passthru.override finalAttrs.finalPackage;
          };
        };

      meta = with lib; {
        homepage = "https://www.postgresql.org";
        description = "Powerful, open source object-relational database system";
        license = licenses.postgresql;
        changelog = "https://www.postgresql.org/docs/release/${finalAttrs.version}/";
        teams = [ teams.postgres ];
        pkgConfigModules = [
          "libecpg"
          "libecpg_compat"
          "libpgtypes"
          "libpq"
        ];
        platforms = platforms.unix;

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
        #
        # Note: This is "host canExecute build" on purpose, since this is about the LLVM that is called
        # to do JIT at **runtime**.
        broken = jitSupport && !stdenv.hostPlatform.canExecute stdenv.buildPlatform;
      };
    });

  postgresqlWithPackages =
    {
      postgresql,
      buildEnv,
      lib,
      makeBinaryWrapper,
    }:
    f:
    let
      installedExtensions = f postgresql.pkgs;
      finalPackage = buildEnv {
        name = "${postgresql.pname}-and-plugins-${postgresql.version}";
        paths = installedExtensions ++ [
          # consider keeping in-sync with `postBuild` below
          postgresql
          postgresql.man # in case user installs this into environment
        ];

        pathsToLink = [
          "/"
          "/bin"
          "/share/postgresql/extension"
          # Unbreaks Omnigres' build system
          "/share/postgresql/timezonesets"
          "/share/postgresql/tsearch_data"
        ];

        nativeBuildInputs = [ makeBinaryWrapper ];
        postBuild =
          let
            args = lib.concatMap (ext: ext.wrapperArgs or [ ]) installedExtensions;
          in
          ''
            wrapProgram "$out/bin/postgres" ${lib.concatStringsSep " " args}
          '';

        passthru = {
          inherit installedExtensions;
          inherit (postgresql)
            pkgs
            psqlSchema
            version
            ;

          pg_config = postgresql.pg_config.override {
            outputs = {
              out = finalPackage;
              man = finalPackage;
            };
          };

          withJIT = postgresqlWithPackages {
            inherit
              buildEnv
              lib
              makeBinaryWrapper
              postgresql
              ;
          } (_: installedExtensions ++ [ postgresql.jit ]);
          withoutJIT = postgresqlWithPackages {
            inherit
              buildEnv
              lib
              makeBinaryWrapper
              postgresql
              ;
          } (_: lib.remove postgresql.jit installedExtensions);

          withPackages =
            f':
            postgresqlWithPackages {
              inherit
                buildEnv
                lib
                makeBinaryWrapper
                postgresql
                ;
            } (ps: installedExtensions ++ f' ps);
        };
      };
    in
    finalPackage;

in
# passed by <major>.nix
versionArgs:
# passed by default.nix
{ self, ... }@defaultArgs:
self.callPackage generic (defaultArgs // versionArgs)
