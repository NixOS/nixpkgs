let

  generic =
      # dependencies
      { stdenv, lib, fetchurl, makeWrapper
      , glibc, zlib, readline, openssl, icu, lz4, zstd, systemd, libossp_uuid
      , pkg-config, libxml2, tzdata, libkrb5

      # This is important to obtain a version of `libpq` that does not depend on systemd.
      , enableSystemd ? !stdenv.isDarwin && !stdenv.hostPlatform.isStatic
      , gssSupport ? with stdenv.hostPlatform; !isWindows && !isStatic

      # for postgresql.pkgs
      , this, self, newScope, buildEnv

      # source specification
      , version, hash, psqlSchema,

      # for tests
      nixosTests, thisAttr
    }:
  let
    atLeast = lib.versionAtLeast version;
    lz4Enabled = atLeast "14";
    zstdEnabled = atLeast "15";

  in stdenv.mkDerivation rec {
    pname = "postgresql";
    inherit version;

    src = fetchurl {
      url = "mirror://postgresql/source/v${version}/${pname}-${version}.tar.bz2";
      inherit hash;
    };

    hardeningEnable = lib.optionals (!stdenv.cc.isClang) [ "pie" ];

    outputs = [ "out" "lib" "doc" "man" ];
    setOutputFlags = false; # $out retains configureFlags :-/

    buildInputs = [
      zlib
      readline
      openssl
      libxml2
      icu
    ]
      ++ lib.optionals lz4Enabled [ lz4 ]
      ++ lib.optionals zstdEnabled [ zstd ]
      ++ lib.optionals enableSystemd [ systemd ]
      ++ lib.optionals gssSupport [ libkrb5 ]
      ++ lib.optionals (!stdenv.isDarwin) [ libossp_uuid ];

    nativeBuildInputs = [
      makeWrapper
      pkg-config
    ];

    enableParallelBuilding = !stdenv.isDarwin;

    separateDebugInfo = true;

    buildFlags = [ "world" ];

    NIX_CFLAGS_COMPILE = "-I${libxml2.dev}/include/libxml2";

    # Otherwise it retains a reference to compiler and fails; see #44767.  TODO: better.
    preConfigure = "CC=${stdenv.cc.targetPrefix}cc";

    configureFlags = [
      "--with-openssl"
      "--with-libxml"
      "--with-icu"
      "--sysconfdir=/etc"
      "--libdir=$(lib)/lib"
      "--with-system-tzdata=${tzdata}/share/zoneinfo"
      "--enable-debug"
      (lib.optionalString enableSystemd "--with-systemd")
      (if stdenv.isDarwin then "--with-uuid=e2fs" else "--with-ossp-uuid")
    ] ++ lib.optionals lz4Enabled [ "--with-lz4" ]
      ++ lib.optionals zstdEnabled [ "--with-zstd" ]
      ++ lib.optionals gssSupport [ "--with-gssapi" ]
      ++ lib.optionals stdenv.hostPlatform.isRiscV [ "--disable-spinlocks" ];

    patches = [
      ./patches/disable-resolve_symlinks.patch
      ./patches/less-is-more.patch
      ./patches/hardcode-pgxs-path.patch
      ./patches/specify_pkglibdir_at_runtime.patch
      ./patches/findstring.patch
    ] ++ lib.optionals stdenv.isLinux [
      (if atLeast "13" then ./patches/socketdir-in-run-13.patch else ./patches/socketdir-in-run.patch)
    ];

    installTargets = [ "install-world" ];

    LC_ALL = "C";

    postPatch = ''
      # Hardcode the path to pgxs so pg_config returns the path in $out
      substituteInPlace "src/common/config_info.c" --replace HARDCODED_PGXS_PATH "$out/lib"
    '';

    postInstall =
      ''
        moveToOutput "lib/pgxs" "$out" # looks strange, but not deleting it
        moveToOutput "lib/libpgcommon*.a" "$out"
        moveToOutput "lib/libpgport*.a" "$out"
        moveToOutput "lib/libecpg*" "$out"

        # Prevent a retained dependency on gcc-wrapper.
        substituteInPlace "$out/lib/pgxs/src/Makefile.global" --replace ${stdenv.cc}/bin/ld ld

        if [ -z "''${dontDisableStatic:-}" ]; then
          # Remove static libraries in case dynamic are available.
          for i in $out/lib/*.a $lib/lib/*.a; do
            name="$(basename "$i")"
            ext="${stdenv.hostPlatform.extensions.sharedLibrary}"
            if [ -e "$lib/lib/''${name%.a}$ext" ] || [ -e "''${i%.a}$ext" ]; then
              rm "$i"
            fi
          done
        fi
      '';

    postFixup = lib.optionalString (!stdenv.isDarwin && stdenv.hostPlatform.libc == "glibc")
      ''
        # initdb needs access to "locale" command from glibc.
        wrapProgram $out/bin/initdb --prefix PATH ":" ${glibc.bin}/bin
      '';

    doCheck = !stdenv.isDarwin;
    # autodetection doesn't seem to able to find this, but it's there.
    checkTarget = "check";

    preCheck =
      # On musl, comment skip the following tests, because they break due to
      #     ! ERROR:  could not load library "/build/postgresql-11.5/tmp_install/nix/store/...-postgresql-11.5-lib/lib/libpqwalreceiver.so": Error loading shared library libpq.so.5: No such file or directory (needed by /build/postgresql-11.5/tmp_install/nix/store/...-postgresql-11.5-lib/lib/libpqwalreceiver.so)
      # See also here:
      #     https://git.alpinelinux.org/aports/tree/main/postgresql/disable-broken-tests.patch?id=6d7d32c12e073a57a9e5946e55f4c1fbb68bd442
      if stdenv.hostPlatform.isMusl then ''
        substituteInPlace src/test/regress/parallel_schedule \
          --replace "subscription" "" \
          --replace "object_address" ""
      '' else null;

    doInstallCheck = false; # needs a running daemon?

    disallowedReferences = [ stdenv.cc ];

    passthru = {
      inherit readline psqlSchema;

      pkgs = let
        scope = { postgresql = this; };
        newSelf = self // scope;
        newSuper = { callPackage = newScope (scope // this.pkgs); };
      in import ./packages.nix newSelf newSuper;

      withPackages = postgresqlWithPackages {
                       inherit makeWrapper buildEnv;
                       postgresql = this;
                     }
                     this.pkgs;

      tests.postgresql = nixosTests.postgresql-wal-receiver.${thisAttr};
    };

    meta = with lib; {
      homepage    = "https://www.postgresql.org";
      description = "A powerful, open source object-relational database system";
      license     = licenses.postgresql;
      maintainers = with maintainers; [ thoughtpolice danbst globin marsam ivan ];
      platforms   = platforms.unix;
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

in self: {

  postgresql_11 = self.callPackage generic {
    version = "11.18";
    psqlSchema = "11.1"; # should be 11, but changing it is invasive
    hash = "sha256-0k8g78UukYrPvMoh6c6ijg4mO4RqDECPz6w7PEoPdQQ=";
    this = self.postgresql_11;
    thisAttr = "postgresql_11";
    inherit self;
  };

  postgresql_12 = self.callPackage generic {
    version = "12.13";
    psqlSchema = "12";
    hash = "sha256-tsYjBGr0VI8RqEtAeTTWddEe0HDHk9FbBGg79fMi4C0=";
    this = self.postgresql_12;
    thisAttr = "postgresql_12";
    inherit self;
  };

  postgresql_13 = self.callPackage generic {
    version = "13.9";
    psqlSchema = "13";
    hash = "sha256-7xlmwKXkn77TNwrSgkkoy2sRZGF67q4WBtooP38zpBU=";
    this = self.postgresql_13;
    thisAttr = "postgresql_13";
    inherit self;
  };

  postgresql_14 = self.callPackage generic {
    version = "14.6";
    psqlSchema = "14";
    hash = "sha256-UIhA/BgJ05q3InTV8Tfau5/X+0+TPaQWiu67IAae3yI=";
    this = self.postgresql_14;
    thisAttr = "postgresql_14";
    inherit self;
  };

  postgresql_15 = self.callPackage generic {
    version = "15.1";
    psqlSchema = "15";
    hash = "sha256-ZP3yPXNK+tDf5Ad9rKlqxR3NaX5ori09TKbEXLFOIa4=";
    this = self.postgresql_15;
    thisAttr = "postgresql_15";
    inherit self;
  };
}
