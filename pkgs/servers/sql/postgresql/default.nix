{ stdenv, lib, fetchurl, makeWrapper
, glibc, zlib, readline, libossp_uuid, openssl, libxml2, tzdata, systemd
}:

let

  common = { version, sha256, psqlSchema }:
   let atLeast = lib.versionAtLeast version; in stdenv.mkDerivation (rec {
    name = "postgresql-${version}";

    src = fetchurl {
      url = "mirror://postgresql/source/v${version}/${name}.tar.bz2";
      inherit sha256;
    };

    outputs = [ "out" "lib" "doc" "man" ];
    setOutputFlags = false; # $out retains configureFlags :-/

    buildInputs =
      [ zlib readline openssl libxml2 makeWrapper ]
      ++ lib.optionals (!stdenv.isDarwin) [ libossp_uuid ]
      ++ lib.optionals (atLeast "9.6" && !stdenv.isDarwin) [ systemd ];

    enableParallelBuilding = true;

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
    ];

    patches =
      [ (if atLeast "9.4" then ./disable-resolve_symlinks-94.patch else ./disable-resolve_symlinks.patch)
        (if atLeast "9.6" then ./less-is-more-96.patch             else ./less-is-more.patch)
        (if atLeast "9.6" then ./hardcode-pgxs-path-96.patch       else ./hardcode-pgxs-path.patch)
        ./specify_pkglibdir_at_runtime.patch
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
        moveToOutput "lib/libpgcommon.a" "$out"
        moveToOutput "lib/libpgport.a" "$out"
        moveToOutput "lib/libecpg*" "$out"

        # Prevent a retained dependency on gcc-wrapper.
        substituteInPlace "$out/lib/pgxs/src/Makefile.global" --replace ${stdenv.cc}/bin/ld ld

        if [ -z "''${dontDisableStatic:-}" ]; then
          # Remove static libraries in case dynamic are available.
          for i in $out/lib/*.a $lib/lib/*.a; do
            name="$(basename "$i")"
            if [ -e "$lib/lib/''${name%.a}.so" ] || [ -e "''${i%.a}.so" ]; then
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
      homepage = https://www.postgresql.org;
      description = "A powerful, open source object-relational database system";
      license = licenses.postgresql;
      maintainers = [ maintainers.ocharles ];
      platforms = platforms.unix;
      knownVulnerabilities = optional (!atLeast "9.4")
        "PostgreSQL versions older than 9.4 are not maintained anymore!";
    };
  });

in {

  postgresql93 = common {
    version = "9.3.25";
    psqlSchema = "9.3";
    sha256 = "1nxn0hjrg4y5v5n2jgzrbicgv4504r2yfjyk6g6rq0sx8603x5g4";
  };

  postgresql94 = common {
    version = "9.4.21";
    psqlSchema = "9.4";
    sha256 = "01k0s3a7qy8639zsjp1bjbfnnymyl0rgyylrjbkm81m0779b8j80";
  };

  postgresql95 = common {
    version = "9.5.16";
    psqlSchema = "9.5";
    sha256 = "0cg10ri0475vg1c8k1sb5qi4i64hiv9k7crmg15qvvnwsjanqmx4";
  };

  postgresql96 = common {
    version = "9.6.12";
    psqlSchema = "9.6";
    sha256 = "114xay230xia2fagisxahs5fc2mza8hmmkr6ibd7nxllp938931f";
  };

  postgresql100 = common {
    version = "10.7";
    psqlSchema = "10.0";
    sha256 = "1piyfcrcqscjhnnwn91kdvr764s7d0qz4lgygf9bl6qc71ji1vdz";
  };

}
