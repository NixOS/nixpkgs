{ lib, stdenv, glibc, fetchurl, zlib, readline, libossp_uuid, openssl, libxml2, makeWrapper }:

let

  common = { version, sha256, psqlSchema } @ args:
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
      ++ lib.optionals (!stdenv.isDarwin) [ libossp_uuid ];

    enableParallelBuilding = true;

    makeFlags = [ "world" ];

    configureFlags = [
      "--with-openssl"
      "--with-libxml"
      "--sysconfdir=/etc"
      "--libdir=$(lib)/lib"
    ]
      ++ lib.optional (stdenv.isDarwin)  "--with-uuid=e2fs"
      ++ lib.optional (!stdenv.isDarwin) "--with-ossp-uuid";

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
        moveToOutput "lib/*.a" "$out"
        moveToOutput "lib/libecpg*" "$out"

        # Prevent a retained dependency on gcc-wrapper.
        substituteInPlace "$out/lib/pgxs/src/Makefile.global" --replace ${stdenv.cc}/bin/ld ld

        # Remove static libraries in case dynamic are available.
        for i in $out/lib/*.a; do
          name="$(basename "$i")"
          if [ -e "$lib/lib/''${name%.a}.so" ] || [ -e "''${i%.a}.so" ]; then
            rm "$i"
          fi
        done
      '';

    postFixup = lib.optionalString (!stdenv.isDarwin)
      ''
        # initdb needs access to "locale" command from glibc.
        wrapProgram $out/bin/initdb --prefix PATH ":" ${glibc.bin}/bin
      '';

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
    };
  });

in {

  postgresql93 = common {
    version = "9.3.20";
    psqlSchema = "9.3";
    sha256 = "1jp6lac4b0q6hb28yrdsl0ymzn75gg59hvp5zasarf3mf3b8l4zb";
  };

  postgresql94 = common {
    version = "9.4.15";
    psqlSchema = "9.4";
    sha256 = "1i5c67gg4fj38hk07h6w6m4mqak84bhnblqsjbpiamg4x33v7gqj";
  };

  postgresql95 = common {
    version = "9.5.10";
    psqlSchema = "9.5";
    sha256 = "10gjfn16bhzkmlqfsn384w49db0j39bg3n4majwxdpjd17g7lpcl";
  };

  postgresql96 = common {
    version = "9.6.6";
    psqlSchema = "9.6";
    sha256 = "0m417h30s18rwa7yzkqqcdb22ifpcda2fpg2cyx8bxvjp3ydz71r";
  };

  postgresql100 = common {
    version = "10.1";
    psqlSchema = "10.0";
    sha256 = "04z7lm4h94625vbncwv98svycqr942n3q47ailqaczkszqjlxjrw";
  };

}
