{ lib, stdenv, fetchurl, zlib, readline, libossp_uuid, openssl }:

let

  common = { version, sha256, psqlSchema } @ args: stdenv.mkDerivation (rec {
    name = "postgresql-${version}";

    src = fetchurl {
      url = "mirror://postgresql/source/v${version}/${name}.tar.bz2";
      inherit sha256;
    };

    outputs = [ "out" "lib" "doc" ];
    setOutputFlags = false; # $out retains configureFlags :-/

    buildInputs =
      [ zlib readline openssl ]
      ++ lib.optionals (!stdenv.isDarwin) [ libossp_uuid ];

    enableParallelBuilding = true;

    makeFlags = [ "world" ];

    configureFlags = [
      "--with-openssl"
      "--sysconfdir=/etc"
      "--libdir=$(lib)/lib"
    ]
      ++ lib.optional (stdenv.isDarwin)  "--with-uuid=e2fs"
      ++ lib.optional (!stdenv.isDarwin) "--with-ossp-uuid";

    patches =
      [ (if lib.versionAtLeast version "9.4" then ./disable-resolve_symlinks-94.patch else ./disable-resolve_symlinks.patch)
        ./less-is-more.patch
        ./hardcode-pgxs-path.patch
        ./specify_pkglibdir_at_runtime.patch
      ];

    installTargets = [ "install-world" ];

    LC_ALL = "C";

    postConfigure =
      ''
        # Hardcode the path to pgxs so pg_config returns the path in $out
        substituteInPlace "src/bin/pg_config/pg_config.c" --replace HARDCODED_PGXS_PATH $out/lib
      '';

    postInstall =
      ''
        moveToOutput "lib/pgxs" "$out" # looks strange, but not deleting it
        moveToOutput "lib/*.a" "$out"
        moveToOutput "lib/libecpg*" "$out"

        # Prevent a retained dependency on gcc-wrapper.
        substituteInPlace "$out/lib/pgxs/src/Makefile.global" --replace ${stdenv.cc}/bin/ld ld
      '';

    disallowedReferences = [ stdenv.cc ];

    passthru = {
      inherit readline psqlSchema;
    };

    meta = with lib; {
      homepage = http://www.postgresql.org/;
      description = "A powerful, open source object-relational database system";
      license = licenses.postgresql;
      maintainers = [ maintainers.ocharles ];
      platforms = platforms.unix;
      hydraPlatforms = platforms.linux;
    };
  });

in {

  postgresql91 = common {
    version = "9.1.24";
    psqlSchema = "9.1";
    sha256 = "1lz5ibvgz6cxprxlnd7a8iwv387idr7k53bdsvy4bw9ayglq83fy";
  };

  postgresql92 = common {
    version = "9.2.19";
    psqlSchema = "9.2";
    sha256 = "1bfvx1h1baxp40y4xi88974p43vazz13mwc0h8scq3sr9wxdfa8x";
  };

  postgresql93 = common {
    version = "9.3.15";
    psqlSchema = "9.3";
    sha256 = "0kswvs4rzcmjz12hhyi61w5x2wh4dxskar8v7rgajfm98qabmz59";
  };

  postgresql94 = common {
    version = "9.4.10";
    psqlSchema = "9.4";
    sha256 = "1kvfhalf3rs59887b5qa14zp85zcnsc6pislrs0wd08rxn5nfqbh";
  };

  postgresql95 = common {
    version = "9.5.5";
    psqlSchema = "9.5";
    sha256 = "157kf6mdazmxfmd11f0akya2xcz6sfgprn7yqc26dpklps855ih2";
  };


}
