{ lib, stdenv, glibc, fetchurl, zlib, readline, libossp_uuid, openssl, libxml2, makeWrapper, tzdata }:

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
      ++ lib.optionals (!stdenv.isDarwin) [ libossp_uuid ];

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
      (if stdenv.isDarwin then "--with-uuid=e2fs" else "--with-ossp-uuid")
    ];

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
      description = "A powerful, open source object-relational database system";
      homepage    = https://www.postgresql.org;
      license     = licenses.postgresql;
      maintainers = with maintainers; [ ocharles thoughtpolice ];
      platforms   = platforms.unix;
    };
  });

in {

  postgresql93 = common {
    version = "9.3.24";
    psqlSchema = "9.3";
    sha256 = "1a8dnv16n2rxnbwhqw7c0kjpj3xqvkpwk50kvimj4d917cxaf542";
  };

  postgresql94 = common {
    version = "9.4.19";
    psqlSchema = "9.4";
    sha256 = "12qn9h47rkn4k41gdbxkkvg0pff43k1113jmhc83f19adc1nnxq3";
  };

  postgresql95 = common {
    version = "9.5.14";
    psqlSchema = "9.5";
    sha256 = "0k8s62h6qd9p3xlx315j5irniskqsnx1nz4ir5r1yhqp07mdab1y";
  };

  postgresql96 = common {
    version = "9.6.10";
    psqlSchema = "9.6";
    sha256 = "09l4zqs74fqnazdsyln9x657mq3wsbgng9wpvq71yh26cv2sq5c6";
  };

  # NOTE: starting with PostgreSQL 10, the versioning scheme changed from
  # <supermajor>.<major>.<minor> to <major>.<minor>. Thus there is no longer a
  # 3rd component, and we should name attributes following only the major
  # number.
  postgresql10 = common {
    version = "10.5";
    psqlSchema = "10.0";
    sha256 = "04a07jkvc5s6zgh6jr78149kcjmsxclizsqabjw44ld4j5n633kc";
  };
}
