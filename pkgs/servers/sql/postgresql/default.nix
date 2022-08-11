let

  generic =
      # dependencies
      { stdenv, lib, fetchurl, makeWrapper
      , glibc, zlib, readline, openssl, icu, lz4, systemd, libossp_uuid
      , pkg-config, libxml2, tzdata

      # This is important to obtain a version of `libpq` that does not depend on systemd.
      , enableSystemd ? (lib.versionAtLeast version "9.6" && !stdenv.isDarwin)
      , gssSupport ? with stdenv.hostPlatform; !isWindows && !isStatic, libkrb5


      # for postgreql.pkgs
      , this, self, newScope, buildEnv

      # source specification
      , version, hash, psqlSchema,

      # for tests
      nixosTests, thisAttr
    }:
  let
    atLeast = lib.versionAtLeast version;
    icuEnabled = atLeast "10";
    lz4Enabled = atLeast "14";

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

    buildInputs =
      [ zlib readline openssl libxml2 ]
      ++ lib.optionals icuEnabled [ icu ]
      ++ lib.optionals lz4Enabled [ lz4 ]
      ++ lib.optionals enableSystemd [ systemd ]
      ++ lib.optionals gssSupport [ libkrb5 ]
      ++ lib.optionals (!stdenv.isDarwin) [ libossp_uuid ];

    nativeBuildInputs = [ makeWrapper ] ++ lib.optionals icuEnabled [ pkg-config ];

    enableParallelBuilding = !stdenv.isDarwin;

    separateDebugInfo = true;

    buildFlags = [ "world" ];

    NIX_CFLAGS_COMPILE = "-I${libxml2.dev}/include/libxml2";

    # Otherwise it retains a reference to compiler and fails; see #44767.  TODO: better.
    preConfigure = "CC=${stdenv.cc.targetPrefix}cc";

    configureFlags = [
      "--with-openssl"
      "--with-libxml"
      "--sysconfdir=/etc"
      "--libdir=$(lib)/lib"
      "--with-system-tzdata=${tzdata}/share/zoneinfo"
      "--enable-debug"
      (lib.optionalString enableSystemd "--with-systemd")
      (if stdenv.isDarwin then "--with-uuid=e2fs" else "--with-ossp-uuid")
    ] ++ lib.optionals icuEnabled [ "--with-icu" ]
      ++ lib.optionals lz4Enabled [ "--with-lz4" ]
      ++ lib.optionals gssSupport [ "--with-gssapi" ]
      ++ lib.optionals stdenv.hostPlatform.isRiscV [ "--disable-spinlocks" ];

    patches =
      [ (if atLeast "9.4" then ./patches/disable-resolve_symlinks-94.patch else ./patches/disable-resolve_symlinks.patch)
        (if atLeast "9.6" then ./patches/less-is-more-96.patch             else ./patches/less-is-more.patch)
        (if atLeast "9.6" then ./patches/hardcode-pgxs-path-96.patch       else ./patches/hardcode-pgxs-path.patch)
        ./patches/specify_pkglibdir_at_runtime.patch
        ./patches/findstring.patch
      ]
      ++ lib.optional stdenv.isLinux (if atLeast "13" then ./patches/socketdir-in-run-13.patch else ./patches/socketdir-in-run.patch);

    installTargets = [ "install-world" ];

    LC_ALL = "C";

    postConfigure =
      let path = if atLeast "9.6" then "src/common/config_info.c" else "src/bin/pg_config/pg_config.c"; in
        ''
          # Hardcode the path to pgxs so pg_config returns the path in $out
          substituteInPlace "${path}" --replace HARDCODED_PGXS_PATH $out/lib
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
      knownVulnerabilities = optional (!atLeast "9.4")
        "PostgreSQL versions older than 9.4 are not maintained anymore!";
    };
  };

  postgresqlWithPackages = { postgresql, makeWrapper, buildEnv }: pkgs: f: buildEnv {
    name = "postgresql-and-plugins-${postgresql.version}";
    paths = f pkgs ++ [
        postgresql
        postgresql.lib
        postgresql.man   # in case user installs this into environment
    ];
    buildInputs = [ makeWrapper ];


    # We include /bin to ensure the $out/bin directory is created, which is
    # needed because we'll be removing the files from that directory in postBuild
    # below. See #22653
    pathsToLink = ["/" "/bin"];

    # Note: the duplication of executables is about 4MB size.
    # So a nicer solution was patching postgresql to allow setting the
    # libdir explicitely.
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

  postgresql_10 = self.callPackage generic {
    version = "10.22";
    psqlSchema = "10.0"; # should be 10, but changing it is invasive
    hash = "sha256-lVl3VVxp3xpk9EuB1KGYfrdKu9GHBXn1rZ2UYTPdjk0=";
    this = self.postgresql_10;
    thisAttr = "postgresql_10";
    inherit self;
    icu = self.icu67;
  };

  postgresql_11 = self.callPackage generic {
    version = "11.17";
    psqlSchema = "11.1"; # should be 11, but changing it is invasive
    hash = "sha256-bphJY64HZeYVd5lRA6fmWU2w8L0BUorBI+DeSmpMtMQ=";
    this = self.postgresql_11;
    thisAttr = "postgresql_11";
    inherit self;
  };

  postgresql_12 = self.callPackage generic {
    version = "12.12";
    psqlSchema = "12";
    hash = "sha256-NLPxxpQI4iBowMcbGCdpHxyJFTsK1XbBpE+JIKhYA5w=";
    this = self.postgresql_12;
    thisAttr = "postgresql_12";
    inherit self;
  };

  postgresql_13 = self.callPackage generic {
    version = "13.8";
    psqlSchema = "13";
    hash = "sha256-c4dv3TpRcIc0BFjcpM4VuNKk286zNMBEFCRVGubEze0=";
    this = self.postgresql_13;
    thisAttr = "postgresql_13";
    inherit self;
  };

  postgresql_14 = self.callPackage generic {
    version = "14.5";
    psqlSchema = "14";
    hash = "sha256-1PcstfuFfJqfdeyM8JGhdxJygC8hePCy5lt7b/ZPSjA=";
    this = self.postgresql_14;
    thisAttr = "postgresql_14";
    inherit self;
  };
}
