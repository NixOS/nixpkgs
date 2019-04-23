let

  generic =
      # dependencies
      { stdenv, lib, fetchurl, makeWrapper
      , glibc, zlib, readline, openssl, icu, systemd, libossp_uuid
      , pkgconfig, libxml2, tzdata

      # for postgreql.pkgs
      , this, self, newScope, buildEnv

      # source specification
      , version, sha256, psqlSchema
    }:
  let
    atLeast = lib.versionAtLeast version;
    icuEnabled = atLeast "10";

  in stdenv.mkDerivation rec {
    name = "postgresql-${version}";
    inherit version;

    src = fetchurl {
      url = "mirror://postgresql/source/v${version}/${name}.tar.bz2";
      inherit sha256;
    };

    outputs = [ "out" "lib" "doc" "man" ];
    setOutputFlags = false; # $out retains configureFlags :-/

    buildInputs =
      [ zlib readline openssl libxml2 makeWrapper ]
      ++ lib.optionals icuEnabled [ icu ]
      ++ lib.optionals (atLeast "9.6" && !stdenv.isDarwin) [ systemd ]
      ++ lib.optionals (!stdenv.isDarwin) [ libossp_uuid ];

    nativeBuildInputs = lib.optionals icuEnabled [ pkgconfig ];

    enableParallelBuilding = !stdenv.isDarwin;

    makeFlags = [ "world" ];

    NIX_CFLAGS_COMPILE = [ "-I${libxml2.dev}/include/libxml2" ];

    # Otherwise it retains a reference to compiler and fails; see #44767.  TODO: better.
    preConfigure = "CC=${stdenv.cc.targetPrefix}cc";

    configureFlags = [
      "--with-openssl"
      "--with-libxml"
      "--sysconfdir=/etc"
      "--libdir=$(lib)/lib"
      "--with-system-tzdata=${tzdata}/share/zoneinfo"
      (lib.optionalString (atLeast "9.6" && !stdenv.isDarwin) "--with-systemd")
      (if stdenv.isDarwin then "--with-uuid=e2fs" else "--with-ossp-uuid")
    ] ++ lib.optionals icuEnabled [ "--with-icu" ];

    patches =
      [ (if atLeast "9.4" then ./patches/disable-resolve_symlinks-94.patch else ./patches/disable-resolve_symlinks.patch)
        (if atLeast "9.6" then ./patches/less-is-more-96.patch             else ./patches/less-is-more.patch)
        (if atLeast "9.6" then ./patches/hardcode-pgxs-path-96.patch       else ./patches/hardcode-pgxs-path.patch)
        ./patches/specify_pkglibdir_at_runtime.patch
      ] ++ lib.optional stdenv.isLinux ./patches/socketdir-in-run.patch;

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
        moveToOutput "lib/libpgcommon.a" "$out"
        moveToOutput "lib/libpgport.a" "$out"
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

    doInstallCheck = false; # needs a running daemon?

    disallowedReferences = [ stdenv.cc ];

    passthru = {
      inherit readline psqlSchema version;

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
    };

    meta = with lib; {
      homepage    = https://www.postgresql.org;
      description = "A powerful, open source object-relational database system";
      license     = licenses.postgresql;
      maintainers = with maintainers; [ ocharles thoughtpolice danbst ];
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

    postBuild = ''
      mkdir -p $out/bin
      rm $out/bin/{pg_config,postgres,pg_ctl}
      cp --target-directory=$out/bin ${postgresql}/bin/{postgres,pg_config,pg_ctl}
      wrapProgram $out/bin/postgres --set NIX_PGLIBDIR $out/lib
    '';
  };

in self: {

  postgresql_9_4 = self.callPackage generic {
    version = "9.4.21";
    psqlSchema = "9.4";
    sha256 = "01k0s3a7qy8639zsjp1bjbfnnymyl0rgyylrjbkm81m0779b8j80";
    this = self.postgresql_9_4;
    inherit self;
  };

  postgresql_9_5 = self.callPackage generic {
    version = "9.5.16";
    psqlSchema = "9.5";
    sha256 = "0cg10ri0475vg1c8k1sb5qi4i64hiv9k7crmg15qvvnwsjanqmx4";
    this = self.postgresql_9_5;
    inherit self;
  };

  postgresql_9_6 = self.callPackage generic {
    version = "9.6.12";
    psqlSchema = "9.6";
    sha256 = "114xay230xia2fagisxahs5fc2mza8hmmkr6ibd7nxllp938931f";
    this = self.postgresql_9_6;
    inherit self;
  };

  postgresql_10 = self.callPackage generic {
    version = "10.7";
    psqlSchema = "10.0"; # should be 10, but changing it is invasive
    sha256 = "1piyfcrcqscjhnnwn91kdvr764s7d0qz4lgygf9bl6qc71ji1vdz";
    this = self.postgresql_10;
    inherit self;
  };

  postgresql_11 = self.callPackage generic {
    version = "11.2";
    psqlSchema = "11.1"; # should be 11, but changing it is invasive
    sha256 = "01clq2lw0v83zh5dc89xdr3mmap0jr37kdkh401ph6f2177bjxi6";
    this = self.postgresql_11;
    inherit self;
  };

}
