{ lib, stdenv, glibc, fetchurl, zlib, readline, libossp_uuid, openssl, makeWrapper }:

let

  common = { version, sha256, psqlSchema } @ args:
   let atLeast = lib.versionAtLeast version; in stdenv.mkDerivation (rec {
    name = "postgresql-${version}";

    src = fetchurl {
      url = "mirror://postgresql/source/v${version}/${name}.tar.bz2";
      inherit sha256;
    };

    outputs = [ "out" "lib" "doc" ];
    setOutputFlags = false; # $out retains configureFlags :-/

    buildInputs =
      [ zlib readline openssl makeWrapper ]
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
      '';

    postFixup =
      ''
        # initdb needs access to "locale" command from glibc.
        wrapProgram $out/bin/initdb --prefix PATH ":" ${glibc.bin}/bin
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

  postgresql96 = common {
    version = "9.6.1";
    psqlSchema = "9.6";
    sha256 = "1k8zwnabsl8f7vlp3azm4lrklkb9jkaxmihqf0mc27ql9451w475";
  };

}
