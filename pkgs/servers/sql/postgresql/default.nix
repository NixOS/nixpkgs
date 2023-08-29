let

  generic =
      # dependencies
      { stdenv, lib, fetchurl, makeWrapper, fetchpatch
      , glibc, zlib, readline, openssl, icu, lz4, zstd, systemd, libossp_uuid
      , pkg-config, libxml2, tzdata, libkrb5, substituteAll, darwin

      # This is important to obtain a version of `libpq` that does not depend on systemd.
      , enableSystemd ? lib.meta.availableOn stdenv.hostPlatform systemd && !stdenv.hostPlatform.isStatic
      , gssSupport ? with stdenv.hostPlatform; !isWindows && !isStatic

      # for postgresql.pkgs
      , this, self, newScope, buildEnv

      # source specification
      , version, hash, psqlSchema

      # for tests
      , nixosTests, thisAttr

      # JIT
      , jitSupport ? false
      , nukeReferences, patchelf, llvmPackages
      , makeRustPlatform, buildPgxExtension, cargo, rustc

      # detection of crypt fails when using llvm stdenv, so we add it manually
      # for <13 (where it got removed: https://github.com/postgres/postgres/commit/c45643d618e35ec2fe91438df15abd4f3c0d85ca)
      , libxcrypt
    }:
  let
    atLeast = lib.versionAtLeast version;
    olderThan = lib.versionOlder version;
    lz4Enabled = atLeast "14";
    zstdEnabled = atLeast "15";

    stdenv' = if jitSupport then llvmPackages.stdenv else stdenv;
  in stdenv'.mkDerivation rec {
    pname = "postgresql";
    inherit version;

    src = fetchurl {
      url = "mirror://postgresql/source/v${version}/${pname}-${version}.tar.bz2";
      inherit hash;
    };

    hardeningEnable = lib.optionals (!stdenv'.cc.isClang) [ "pie" ];

    outputs = [ "out" "lib" "doc" "man" ];
    setOutputFlags = false; # $out retains configureFlags :-/

    buildInputs = [
      zlib
      readline
      openssl
      libxml2
      icu
    ]
      ++ lib.optionals (olderThan "13") [ libxcrypt ]
      ++ lib.optionals jitSupport [ llvmPackages.llvm ]
      ++ lib.optionals lz4Enabled [ lz4 ]
      ++ lib.optionals zstdEnabled [ zstd ]
      ++ lib.optionals enableSystemd [ systemd ]
      ++ lib.optionals gssSupport [ libkrb5 ]
      ++ lib.optionals (!stdenv'.isDarwin) [ libossp_uuid ];

    nativeBuildInputs = [
      makeWrapper
      pkg-config
    ]
      ++ lib.optionals jitSupport [ llvmPackages.llvm.dev nukeReferences patchelf ];

    enableParallelBuilding = !stdenv'.isDarwin;

    separateDebugInfo = true;

    buildFlags = [ "world" ];

    env.NIX_CFLAGS_COMPILE = "-I${libxml2.dev}/include/libxml2";

    # Otherwise it retains a reference to compiler and fails; see #44767.  TODO: better.
    preConfigure = "CC=${stdenv'.cc.targetPrefix}cc";

    configureFlags = [
      "--with-openssl"
      "--with-libxml"
      "--with-icu"
      "--sysconfdir=/etc"
      "--libdir=$(lib)/lib"
      "--with-system-tzdata=${tzdata}/share/zoneinfo"
      "--enable-debug"
      (lib.optionalString enableSystemd "--with-systemd")
      (if stdenv'.isDarwin then "--with-uuid=e2fs" else "--with-ossp-uuid")
    ] ++ lib.optionals lz4Enabled [ "--with-lz4" ]
      ++ lib.optionals zstdEnabled [ "--with-zstd" ]
      ++ lib.optionals gssSupport [ "--with-gssapi" ]
      ++ lib.optionals stdenv'.hostPlatform.isRiscV [ "--disable-spinlocks" ]
      ++ lib.optionals jitSupport [ "--with-llvm" ];

    patches = [
      ./patches/disable-resolve_symlinks.patch
      ./patches/less-is-more.patch
      ./patches/hardcode-pgxs-path.patch
      ./patches/specify_pkglibdir_at_runtime.patch
      ./patches/findstring.patch

      (substituteAll {
        src = ./locale-binary-path.patch;
        locale = "${if stdenv.isDarwin then darwin.adv_cmds else lib.getBin stdenv.cc.libc}/bin/locale";
      })

    ] ++ lib.optionals (stdenv'.hostPlatform.isMusl && atLeast "12") [
      (fetchpatch {
        url = "https://git.alpinelinux.org/aports/plain/main/postgresql14/icu-collations-hack.patch?id=56999e6d0265ceff5c5239f85fdd33e146f06cb7";
        hash = "sha256-Yb6lMBDqeVP/BLMyIr5rmR6OkaVzo68cV/+cL2LOe/M=";
      })
    ] ++ lib.optionals (stdenv'.hostPlatform.isMusl && atLeast "13") [
      (if olderThan "14" then
        fetchpatch {
           url = "https://git.alpinelinux.org/aports/plain/main/postgresql13/disable-test-collate.icu.utf8.patch?id=69faa146ec9fff3b981511068f17f9e629d4688b";
           hash = "sha256-IOOx7/laDYhTz1Q1r6H1FSZBsHCgD4lHvia+/os7CCo=";
         }
       else
         fetchpatch {
           url = "https://git.alpinelinux.org/aports/plain/main/postgresql14/disable-test-collate.icu.utf8.patch?id=56999e6d0265ceff5c5239f85fdd33e146f06cb7";
           hash = "sha256-pnl+wM3/IUyq5iJzk+h278MDA9R0GQXQX8d4wJcB2z4=";
         })
    ] ++ lib.optionals stdenv'.isLinux  [
      (if atLeast "13" then ./patches/socketdir-in-run-13.patch else ./patches/socketdir-in-run.patch)
    ];

    installTargets = [ "install-world" ];

    LC_ALL = "C";

    postPatch = ''
      # Hardcode the path to pgxs so pg_config returns the path in $out
      substituteInPlace "src/common/config_info.c" --replace HARDCODED_PGXS_PATH "$out/lib"
    '' + lib.optionalString jitSupport ''
        # Force lookup of jit stuff in $out instead of $lib
        substituteInPlace src/backend/jit/jit.c --replace pkglib_path \"$out/lib\"
        substituteInPlace src/backend/jit/llvm/llvmjit.c --replace pkglib_path \"$out/lib\"
        substituteInPlace src/backend/jit/llvm/llvmjit_inline.cpp --replace pkglib_path \"$out/lib\"
    '';

    postInstall =
      ''
        moveToOutput "lib/pgxs" "$out" # looks strange, but not deleting it
        moveToOutput "lib/libpgcommon*.a" "$out"
        moveToOutput "lib/libpgport*.a" "$out"
        moveToOutput "lib/libecpg*" "$out"

        # Prevent a retained dependency on gcc-wrapper.
        substituteInPlace "$out/lib/pgxs/src/Makefile.global" --replace ${stdenv'.cc}/bin/ld ld

        if [ -z "''${dontDisableStatic:-}" ]; then
          # Remove static libraries in case dynamic are available.
          for i in $out/lib/*.a $lib/lib/*.a; do
            name="$(basename "$i")"
            ext="${stdenv'.hostPlatform.extensions.sharedLibrary}"
            if [ -e "$lib/lib/''${name%.a}$ext" ] || [ -e "''${i%.a}$ext" ]; then
              rm "$i"
            fi
          done
        fi
      '' + lib.optionalString jitSupport ''
        # Move the bitcode and libllvmjit.so library out of $lib; otherwise, every client that
        # depends on libpq.so will also have libLLVM.so in its closure too, bloating it
        moveToOutput "lib/bitcode" "$out"
        moveToOutput "lib/llvmjit*" "$out"

        # In the case of JIT support, prevent a retained dependency on clang-wrapper
        substituteInPlace "$out/lib/pgxs/src/Makefile.global" --replace ${self.llvmPackages.stdenv.cc}/bin/clang clang
        nuke-refs $out/lib/llvmjit_types.bc $(find $out/lib/bitcode -type f)

        # Stop out depending on the default output of llvm
        substituteInPlace $out/lib/pgxs/src/Makefile.global \
          --replace ${self.llvmPackages.llvm.out}/bin "" \
          --replace '$(LLVM_BINPATH)/' ""

        # Stop out depending on the -dev output of llvm
        substituteInPlace $out/lib/pgxs/src/Makefile.global \
          --replace ${self.llvmPackages.llvm.dev}/bin/llvm-config llvm-config \
          --replace -I${self.llvmPackages.llvm.dev}/include ""

        ${lib.optionalString (!stdenv'.isDarwin) ''
          # Stop lib depending on the -dev output of llvm
          rpath=$(patchelf --print-rpath $out/lib/llvmjit.so)
          nuke-refs -e $out $out/lib/llvmjit.so
          # Restore the correct rpath
          patchelf $out/lib/llvmjit.so --set-rpath "$rpath"
        ''}
      '';

    postFixup = lib.optionalString (!stdenv'.isDarwin && stdenv'.hostPlatform.libc == "glibc")
      ''
        # initdb needs access to "locale" command from glibc.
        wrapProgram $out/bin/initdb --prefix PATH ":" ${glibc.bin}/bin
      '';

    doCheck = !stdenv'.isDarwin;
    # autodetection doesn't seem to able to find this, but it's there.
    checkTarget = "check";

    preCheck =
      # On musl, comment skip the following tests, because they break due to
      #     ! ERROR:  could not load library "/build/postgresql-11.5/tmp_install/nix/store/...-postgresql-11.5-lib/lib/libpqwalreceiver.so": Error loading shared library libpq.so.5: No such file or directory (needed by /build/postgresql-11.5/tmp_install/nix/store/...-postgresql-11.5-lib/lib/libpqwalreceiver.so)
      # See also here:
      #     https://git.alpinelinux.org/aports/tree/main/postgresql/disable-broken-tests.patch?id=6d7d32c12e073a57a9e5946e55f4c1fbb68bd442
      if stdenv'.hostPlatform.isMusl then ''
        substituteInPlace src/test/regress/parallel_schedule \
          --replace "subscription" "" \
          --replace "object_address" ""
      '' else null;

    doInstallCheck = false; # needs a running daemon?

    disallowedReferences = [ stdenv'.cc ];

    passthru = let
      jitToggle = this.override {
        jitSupport = !jitSupport;
        this = jitToggle;
      };
    in
    {
      inherit readline psqlSchema jitSupport;

      withJIT = if jitSupport then this else jitToggle;
      withoutJIT = if jitSupport then jitToggle else this;

      pkgs = let
        scope = {
          postgresql = this;
          stdenv = stdenv';
          buildPgxExtension = buildPgxExtension.override {
            stdenv = stdenv';
            rustPlatform = makeRustPlatform {
              stdenv = stdenv';
              inherit rustc cargo;
            };
          };
        };
        newSelf = self // scope;
        newSuper = { callPackage = newScope (scope // this.pkgs); };
      in import ./packages.nix newSelf newSuper;

      withPackages = postgresqlWithPackages {
                       inherit makeWrapper buildEnv;
                       postgresql = this;
                     }
                     this.pkgs;

      tests = {
        postgresql = nixosTests.postgresql-wal-receiver.${thisAttr};
      } // lib.optionalAttrs jitSupport {
        postgresql-jit = nixosTests.postgresql-jit.${thisAttr};
      };
    } // lib.optionalAttrs jitSupport {
      inherit (llvmPackages) llvm;
    };

    meta = with lib; {
      homepage    = "https://www.postgresql.org";
      description = "A powerful, open source object-relational database system";
      license     = licenses.postgresql;
      maintainers = with maintainers; [ thoughtpolice danbst globin marsam ivan ma27 ];
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
      broken = jitSupport && (stdenv.hostPlatform != stdenv.buildPlatform);
    };
  };

  postgresqlWithPackages = { postgresql, makeWrapper, buildEnv }: pkgs: f: buildEnv {
    name = "postgresql-and-plugins-${postgresql.version}";
    paths = f pkgs ++ [
        postgresql
        postgresql.lib
        postgresql.man   # in case user installs this into environment
    ];
    nativeBuildInputs = [ makeWrapper ];


    # We include /bin to ensure the $out/bin directory is created, which is
    # needed because we'll be removing the files from that directory in postBuild
    # below. See #22653
    pathsToLink = ["/" "/bin"];

    # Note: the duplication of executables is about 4MB size.
    # So a nicer solution was patching postgresql to allow setting the
    # libdir explicitly.
    postBuild = ''
      mkdir -p $out/bin
      rm $out/bin/{pg_config,postgres,pg_ctl}
      cp --target-directory=$out/bin ${postgresql}/bin/{postgres,pg_config,pg_ctl}
      wrapProgram $out/bin/postgres --set NIX_PGLIBDIR $out/lib
    '';

    passthru.version = postgresql.version;
    passthru.psqlSchema = postgresql.psqlSchema;
  };

  mkPackages = self: {
    # TODO: remove ahead of 23.11 branchoff
    # "PostgreSQL 11 will stop receiving fixes on November 9, 2023"
    postgresql_11 = self.callPackage generic {
      version = "11.21";
      psqlSchema = "11.1"; # should be 11, but changing it is invasive
      hash = "sha256-B7CDdHHV3XeyUWazRxjzuhCBa2rWHmkeb8VHzz/P+FA=";
      this = self.postgresql_11;
      thisAttr = "postgresql_11";
      inherit self;
    };

    postgresql_12 = self.callPackage generic {
      version = "12.16";
      psqlSchema = "12";
      hash = "sha256-xfH/96D5Ph7DdGQXsFlCkOzmF7SZXtlbjVJ68LoOOPM=";
      this = self.postgresql_12;
      thisAttr = "postgresql_12";
      inherit self;
    };

    postgresql_13 = self.callPackage generic {
      version = "13.12";
      psqlSchema = "13";
      hash = "sha256-DaHtzuNRS3vHum268MAEmeisFZBmjoeJxQJTpiSfIYs=";
      this = self.postgresql_13;
      thisAttr = "postgresql_13";
      inherit self;
    };

    postgresql_14 = self.callPackage generic {
      version = "14.9";
      psqlSchema = "14";
      hash = "sha256-sf47qbGn86ljfdFlbf2tKIkBYHP9TTXxO1AUPLu2qO8=";
      this = self.postgresql_14;
      thisAttr = "postgresql_14";
      inherit self;
    };

    postgresql_15 = self.callPackage generic {
      version = "15.4";
      psqlSchema = "15";
      hash = "sha256-uuxaS9xENzNmU7bLXZ7Ym+W9XAxYuU4L7O4KmZ5jyPk=";
      this = self.postgresql_15;
      thisAttr = "postgresql_15";
      inherit self;
    };
  };

in self:
  let packages = mkPackages self; in
  packages
  // self.lib.mapAttrs'
    (attrName: postgres: self.lib.nameValuePair "${attrName}_jit" (postgres.override rec {
      jitSupport = true;
      thisAttr = "${attrName}_jit";
      this = self.${thisAttr};
    }))
    packages
