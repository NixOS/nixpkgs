{ lib, stdenv, glibc, fetchurl, zlib, readline, libossp_uuid, openssl, libxml2, makeWrapper, tzdata, systemd, icu, pkgconfig }:

let

  common = { version, sha256, psqlSchema }:
  let
    atLeast = lib.versionAtLeast version;

    # Build with ICU by default on versions that support it
    icuEnabled = atLeast "10";
  in stdenv.mkDerivation (rec {
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
      ];

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
        moveToOutput "lib/*.a" "$out"
        moveToOutput "lib/libecpg*" "$out"

        # Prevent a retained dependency on gcc-wrapper.
        substituteInPlace "$out/lib/pgxs/src/Makefile.global" --replace ${stdenv.cc}/bin/ld ld

        if [ -z "''${dontDisableStatic:-}" ]; then
          # Remove static libraries in case dynamic are available.
          for i in $out/lib/*.a; do
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
      inherit readline psqlSchema;
    };

    meta = with lib; {
      homepage    = https://www.postgresql.org;
      description = "A powerful, open source object-relational database system";
      license     = licenses.postgresql;
      maintainers = with maintainers; [ ocharles thoughtpolice ];
      platforms   = platforms.unix;
      knownVulnerabilities = optional (!atLeast "9.4")
        "PostgreSQL versions older than 9.4 are not maintained anymore!";
    };
  });

in {

  postgresql_9_4 = common {
    version = "9.4.20";
    psqlSchema = "9.4";
    sha256 = "0zzqjz5jrn624hzh04drpj6axh30a9k6bgawid6rwk45nbfxicgf";
  };

  postgresql_9_5 = common {
    version = "9.5.15";
    psqlSchema = "9.5";
    sha256 = "0i2lylgmsmy2g1ixlvl112fryp7jmrd0i2brk8sxb7vzzpg3znnv";
  };

  postgresql_9_6 = common {
    version = "9.6.11";
    psqlSchema = "9.6";
    sha256 = "0c55akrkzqd6p6a8hr0338wk246hl76r9j16p4zn3s51d7f0l99q";
  };

  postgresql_10 = common {
    version = "10.6";
    psqlSchema = "10.0";
    sha256 = "0jv26y3f10svrjxzsgqxg956c86b664azyk2wppzpa5x11pjga38";
  };

  postgresql_11 = common {
    version = "11.1";
    psqlSchema = "11.1";
    sha256 = "026v0sicsh7avzi45waf8shcbhivyxmi7qgn9fd1x0vl520mx0ch";
  };

}
